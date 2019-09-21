<?xml version="1.0"?>

<!-- Senast ändrad 2016-07-01 // Mikael Gunnarsson, Maria Idebrant -->

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
				  font-family : Ubuntu, sans-serif ;
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
				  .alt {		/*icke föredragna namn*/
				  font-size : 0.9em;
				  font-weight : normal;
				  }
				  .error{		/*felmeddelanden*/
				  color: #a00;
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
				<div class="uppslag">
				<h3>
					<!--lägger till konceptets id som id på taggen h3, för att kunna länka till enskilda uppslagsnamn-->
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


					<!--och lägger till konceptets föredragna namn som innehåll i h3-->
					<xsl:value-of select="."/>

				</h3>
				<xsl:variable name="prefLabel">
						<xsl:value-of select="."/>
				</xsl:variable>
				<xsl:if test="count(/rdf:RDF/skos:Concept[skos:prefLabel=$prefLabel])>1 or count(/rdf:RDF/skos:Concept[skos:altLabel=$prefLabel])>0 or count(/rdf:RDF/skos:Concept[skos:hiddenLabel=$prefLabel])>0"><p class="error">Det finns fler koncept med &quot;<xsl:value-of select="."/>
&quot; som föredraget, alternativt eller dolt namn.</p></xsl:if>

				<xsl:variable name="id">
						<xsl:value-of select="parent::skos:Concept/@rdf:about"/>
				</xsl:variable>
				<xsl:if test="count(/rdf:RDF/skos:Concept[@rdf:about=$id])>1"><p class="error">Det finns fler koncept som har &quot;<xsl:value-of select="$id"/>
&quot; som ID. Värdet i rdf:about måste vara unikt.</p></xsl:if>
				<xsl:if test="parent::skos:Concept/@rdf:about[contains(., ' ')]"> <p class="error">Du har angett &quot;<xsl:value-of select="$id" />&quot; som ID för detta koncept. Använd inte IDn med mellanslag.</p></xsl:if>

				</div>
				<div class="right">
					<xsl:if test="../skos:altLabel">
						<div class="clear">
							<div class="notering">
						Används för (UF):
					</div>
							<div class="text">
								<xsl:for-each select="../skos:altLabel">
									<xsl:value-of select="."/>
<br />

									<xsl:variable name="altLabel">
										<xsl:value-of select="."/>
									</xsl:variable>
									<xsl:if test="count(/rdf:RDF/skos:Concept[skos:prefLabel=$altLabel])>0 or count(/rdf:RDF/skos:Concept[skos:altLabel=$altLabel])>1 or count(/rdf:RDF/skos:Concept[skos:hiddenLabel=$altLabel])>0"><p class="error">Det finns fler koncept med &quot;<xsl:value-of select="."/>
&quot; som föredraget, alternativt eller dolt namn.</p></xsl:if>
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
										 <p class="error">Konceptet med föredraget namn &quot;<xsl:value-of select="skos:prefLabel"/>&quot; saknar skos:narrower till detta koncept.</p>
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
										 <p class="error">Konceptet med föredraget namn &quot;<xsl:value-of select="skos:prefLabel"/>&quot; saknar skos:broader till detta koncept.</p>
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
										 <p class="error">Konceptet med föredraget namn &quot;<xsl:value-of select="skos:prefLabel"/>&quot; saknar skos:related till detta koncept.</p>
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
		<xsl:if test="count(//skos:Concept[@rdf:about=$namn])=0"><p class="error">Du har hänvisat till ett koncept med id  <xsl:value-of select="$namn"/>, men vokabulären saknar ett koncept med detta id.</p></xsl:if>
		<!--xsl:if test="count(//skos:Concept[@rdf:about=$namn])>1"><p class="error">Du har hänvisat till ett koncept med id  <xsl:value-of select="$namn"/>, men det finns fler än ett koncept med detta id i din vokabulär.</p></xsl:if-->
	</xsl:template>

</xsl:stylesheet>
