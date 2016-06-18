<?xml version="1.0"?>

<!-- Senast ändrad 2011-11-14 // Maria Idebrant -->

<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns="http://www.w3.org/1999/xhtml" 
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
xmlns:dc="http://purl.org/dc/elements/1.1/">
	
	<xsl:output method="xml" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" media-type="application/xhtml+xml"/>
	
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>
					<xsl:value-of select="rdf:RDF/skos:ConceptScheme/dc:title"/>
				</title>
				<style type="text/css">
				  * {margin : 0}
				  body { 
				  margin : 3em 4em 3em 4em ; 
				  font-family : Verdana, sans-serif ;
				  font-size : 12pt;
				  }
				  h2 {margin-bottom : 1em;}
				  a {text-decoration : none}
				  
				  .post {
				  border-top : 0.1em solid black;
				  width : 70em;
				  padding-top : 1em;
				  }
				  .uppslag {	/* uppslagsorden*/
				  float : left;
				  width : 35%;
				  }
				  .right {
				  float : left;
				  width : 65%;
				  }
				  .notering {	/*mittenfältet med UF, SN etc*/
				  float : left;
				  width : 40%;
				  font-weight : bold;
				  }
				  .text {		/*högra fältet med länkar, beskrivningar etc*/
				  float : right;
				  width : 60%;
				  }
				  .notering, .text, p {
				  padding-bottom : 1em;
				  }
				  .clear {
				  clear : both;
				  }
				  .alt {		/*icke föredragna termer*/
				  font-size : 0.9em;
				  font-weight : normal;
				  }
				</style>
			</head>
			<body>
				<h1>
					<xsl:value-of select="rdf:RDF/skos:ConceptScheme/dc:title"/>
				</h1>
				<h2>
					<xsl:value-of select="rdf:RDF/skos:ConceptScheme/dc:description"/>
				</h2>
				
				<p>
				<xsl:for-each select="rdf:RDF/skos:ConceptScheme/dc:creator">
					<xsl:value-of select="."/>
<br />
				</xsl:for-each>
				</p>

				
				
				<xsl:for-each select="//skos:prefLabel | //skos:altLabel">
					<xsl:sort select="." order="ascending"/>
					<xsl:apply-templates select="."/>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="skos:prefLabel">
		<div class="post clear">
				
				<h3 class="uppslag">
					<xsl:choose>
						<xsl:when test="parent::skos:Concept/@rdf:about[starts-with(., '#')]"><!--kollar ifall id:t börjar med # -->
							<xsl:attribute name="id">
								<xsl:value-of select="substring-after(parent::skos:Concept/@rdf:about, '#')"/><!--sätter allt efter # som id till h3-->
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="id">
								<xsl:value-of select="parent::skos:Concept/@rdf:about"/>
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:value-of select="."/>
				</h3>
				<div class="right">
					<xsl:if test="../skos:altLabel">
						<div class="clear">
							<div class="notering">
						Används för (UF):
					</div>
							<div class="text">
								<xsl:for-each select="../skos:altLabel">
									<xsl:value-of select="."/>
									<br/>
								</xsl:for-each>
							</div>
						</div>
					</xsl:if>
					<xsl:if test="../skos:scopeNote">
						<div class="clear">
							<div class="notering">
						Notera (SN):
					</div>
							<div class="text">
								<xsl:for-each select="../skos:scopeNote">
								<xsl:if test="@rdf:resource">
										<a>
											<xsl:attribute name="href">
												<xsl:value-of select="@rdf:resource"/>
											</xsl:attribute>
											<xsl:value-of select="@rdf:resource"/>
										</a>
										<br/>
									</xsl:if>
									<xsl:value-of select="."/>
								</xsl:for-each>
							</div>
						</div>
					</xsl:if>
					<xsl:if test="../skos:broader | ../skos:broaderTransitive">
						<div class="clear">
							<div class="notering">
						Överordnade koncept (BT):
					</div>
							<div class="text">
								<xsl:for-each select="../skos:broader | ../skos:broaderTransitive">
									<xsl:call-template name="BaseNameResolver">
										<xsl:with-param name="namn">
											<xsl:value-of select="@rdf:resource"/>
										</xsl:with-param>
									</xsl:call-template>
									
									<xsl:variable name="aktuelltKoncept">
										<xsl:value-of select="../@rdf:about"/>
									</xsl:variable>
									<xsl:variable name="relateradTerm">
										<xsl:value-of select="@rdf:resource"/>
									</xsl:variable>
		
									<xsl:for-each select="//skos:Concept[@rdf:about=$relateradTerm]">
										<xsl:if test="count(skos:narrower[@rdf:resource=$aktuelltKoncept] | skos:narrowerTransitive[@rdf:resource=$aktuelltKoncept])!=1">
										 (Korrekt NT för <xsl:value-of select="skos:prefLabel"/> saknas.)
										</xsl:if>
									</xsl:for-each>
									
									<br/>
								</xsl:for-each>
							</div>
						</div>
					</xsl:if>
					<xsl:if test="../skos:narrower | ../skos:narrowerTransitive">
						<div class="clear">
							<div class="notering">
						Underordnade koncept (NT):
					</div>
							<div class="text">
								<xsl:for-each select="../skos:narrower | ../skos:narrowerTransitive">
									<xsl:call-template name="BaseNameResolver">
										<xsl:with-param name="namn">
											<xsl:value-of select="@rdf:resource"/>
										</xsl:with-param>
									</xsl:call-template>
									
									<xsl:variable name="aktuelltKoncept">
										<xsl:value-of select="../@rdf:about"/>
									</xsl:variable>
									<xsl:variable name="relateradTerm">
										<xsl:value-of select="@rdf:resource"/>
									</xsl:variable>
		
									<xsl:for-each select="//skos:Concept[@rdf:about=$relateradTerm]">
										<xsl:if test="count(skos:broader[@rdf:resource=$aktuelltKoncept] | skos:broaderTransitive[@rdf:resource=$aktuelltKoncept])!=1">
										 (Korrekt BT för <xsl:value-of select="skos:prefLabel"/> saknas.)
										</xsl:if>
									</xsl:for-each>
									
									<br/>
								</xsl:for-each>
							</div>
						</div>
					</xsl:if>
					<xsl:if test="../skos:related">
						<div class="clear">
							<div class="notering">
						Relaterade koncept (RT):
					</div>
							<div class="text">
								<xsl:for-each select="../skos:related">
									<xsl:call-template name="BaseNameResolver">
										<xsl:with-param name="namn">
											<xsl:value-of select="@rdf:resource"/>
										</xsl:with-param>
									</xsl:call-template>
									
									<xsl:variable name="aktuelltKoncept">
										<xsl:value-of select="../@rdf:about"/>
									</xsl:variable>
									<xsl:variable name="relateradTerm">
										<xsl:value-of select="@rdf:resource"/>
									</xsl:variable>
		
									<xsl:for-each select="//skos:Concept[@rdf:about=$relateradTerm]">
										<xsl:if test="count(skos:related[@rdf:resource=$aktuelltKoncept])!=1">
										 (Korrekt RT för <xsl:value-of select="skos:prefLabel"/> saknas.)
										</xsl:if>
									</xsl:for-each>
									
									
									<br/>
								</xsl:for-each>
							</div>
						</div>
					</xsl:if>
					<xsl:if test="../skos:definition">
						<div class="clear">
							<div class="notering">
						Definieras som:
					</div>
							<div class="text">
								<xsl:for-each select="../skos:definition">
									<xsl:if test="@rdf:resource">
										<xsl:for-each select="@rdf:resource">
											<a>
												<xsl:attribute name="href">
													<xsl:value-of select="."/>
												</xsl:attribute>
												<xsl:value-of select="."/>
											</a>
<br />
										</xsl:for-each>
									</xsl:if>
									<xsl:value-of select="."/>
									
								</xsl:for-each>
							</div>
						</div>
					</xsl:if>
					<xsl:if test="../skos:example">
						<div class="clear">
							<div class="notering">
						Exempel:
					</div>
							<div class="text">
								<xsl:for-each select="../skos:example">
									<xsl:if test="@rdf:resource">
										<a>
											<xsl:attribute name="href">
												<xsl:value-of select="@rdf:resource"/>
											</xsl:attribute>
											<xsl:value-of select="@rdf:resource"/>
										</a>
										<br/>
									</xsl:if>
									<xsl:value-of select="."/>
								</xsl:for-each>
							</div>
						</div>
					</xsl:if>
				</div>
		</div>
	</xsl:template>
	<xsl:template match="skos:altLabel">
		<div class="post clear">
			<div class="uppslag alt">
<p>
				<xsl:value-of select="."/>
				(icke föredragen term)</p>
			</div>
			<div class="right">
				<div class="notering alt">Använd i stället (USE):</div>
				<div class="text alt">
					<xsl:variable name="koncept">
						<xsl:value-of select="../@rdf:about"/>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="starts-with($koncept, '#')">
							<a href="{$koncept}">
								<xsl:value-of select="../skos:prefLabel"/>
							</a>
						</xsl:when>
						<xsl:when test="starts-with($koncept, 'http://')">
							<a href="{$koncept}">
								<xsl:value-of select="../skos:prefLabel"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<a href="#{$koncept}">
								<xsl:value-of select="../skos:prefLabel"/>
							</a>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div><!--class="right"-->
		</div>
	</xsl:template>
	<xsl:template name="BaseNameResolver">
		<xsl:param name="namn">Unresolved</xsl:param>
									
		<xsl:for-each select="//skos:Concept[@rdf:about=$namn]">
			<xsl:choose>
				<xsl:when test="starts-with($namn, '#')">
					<a href="{$namn}">
						<xsl:value-of select="skos:prefLabel"/>
					</a>
				</xsl:when>
				<xsl:when test="starts-with($namn, 'http://')">
					<a href="{$namn}">
						<xsl:value-of select="skos:prefLabel"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<a href="#{$namn}">
						<xsl:value-of select="skos:prefLabel"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:if test="count(//skos:Concept[@rdf:about=$namn])!=1">Felaktigt attributnamn: <xsl:value-of select="$namn"/></xsl:if>
	</xsl:template>

</xsl:stylesheet>
