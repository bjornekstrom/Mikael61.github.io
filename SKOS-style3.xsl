<?xml version="1.0" encoding="utf-8"?>

<!--Inlämningsuppgift XSL, Kunskapsorganisation 2: XML och bibliografisk kontroll, Maria Idebrant, DV09 2011-05-05-->

<!--Ändringar i stilmallen:
	- BT skrivs ut när de finns. UF skrivs inte ut när den saknar innehåll.
	- USE är en länk precis som BT & NT, eftersom det är rimligt att man vill hitta rätt term smidigt.
	- Text i skos:example skrivs ut.
	- Länkningen inom sidan fungerar.
	- Tabellen är borta. Jag föredrar div:ar för att  koden blir mer överskådlig och det är lättare att använda css:en bra.
	- Alla stilangivelser är flyttade till stilmallen.
	- Har ändrat bredd och lite andra småsaker för att det ska bli lite trevligare att läsa enligt min smak. Till exempel kan rött mot vitt vara svårt att läsa, varför jag valde svart istället. Den gamla stilmallen ger jobbigt långt avstånd mellan vänsterspalten och de båda spalterna till höger också, om man har för bred skärm, så jag har minskat ned det. 
	- Ifall rdf:resource har stavats fel skrivs ett felmeddelande ut där länken skulle varit, istället för att det bara blir en tomrad. Det är lätt att man missar en tomrad, så detta blir lite tydligare.
	- Om man har skrivit in att term A har en relation till term B, men missat att skriva in att term B har motsvarande relation till term A, kommer det att skrivas ut efter länken från term A till term B. Betydligt enklare att se ifall man missat någonting då än att kolla igenom xml-filen själv.

Vill man så kan man naturligtvis lägga till att fler element ska skrivas ut, t ex skos:historyNote, men jag tycker att det räcker bra med de som är i dtd:n.
-->

<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns="http://www.w3.org/1999/xhtml" 
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
xmlns:dc="http://purl.org/dc/elements/1.1/">
	
	<xsl:output method="xml" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" media-type="application/xhtml+xml" encoding="utf-8"/>
	
	
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
				  }
				  .right {
				  float : right;
				  width : 80%;
				  }
				  .notering {	/*mittenfältet med UF, SN etc*/
				  float : left;
				  width : 30%;
				  font-weight : bold;
				  }
				  .text {		/*högra fältet med länkar, beskrivningar etc*/
				  float : right;
				  width : 70%;
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
                  <xsl:value-of select="rdf:RDF/skos:ConceptScheme/dc:creator"/>
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
									<xsl:value-of select="."/>
									<br/>
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
											<br/>
										</xsl:for-each>
									</xsl:if>
									<xsl:value-of select="."/>
									<br/>
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
				<xsl:value-of select="."/>
				<p>(icke föredragen term)</p>
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
