<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns="http://www.w3.org/1999/xhtml" 
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
xmlns:skos="http://www.w3.org/2004/02/skos/core#"
xmlns:dc="http://purl.org/dc/elements/1.1/">
		<xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" media-type="application/xhtml+xml"/>
		<xsl:template match="/">
				<html xmlns="http://www.w3.org/1999/xhtml">
						<head>
								<title><xsl:value-of select="rdf:RDF/skos:ConceptScheme/dc:title"/></title>
								<style type="text/css">
				  * {margin : 0}
				  body { margin : 3em 4em 3em 4em ; 
				  font-family : Verdana, sans-serif ;
				  font-size : 12pt
				  }
				  .UF td { font-weight : bold ;
				  padding : 1em
				  }
				  .BT td { font-weight : bold ;
				  padding : 1em 0 0 1em
				  }
				  .NT td { font-weight : bold ;
				  padding : 1em 0 0 1em
				  }
				  .SN td { font-weight : bold ;
				  padding : 1em 0 0 1em
				  }
				  .RT td { font-weight : bold ;
				  padding : 1em 0 0 1em
				  }
				  .DEF td { font-weight : bold ;
				  padding : 1em 0 0 1em
				  }
				  .EX td { font-weight : bold ;
				  padding : 1em 0 0 1em
				  }
				  .USE td { font-size : 0.9em ;
				  padding : 12pt }
				  .term { width : 35% }
				  .desc { width : 40% }
				  a {
				  text-decoration : none
				  }
				</style>
						</head>
						<body><h1>
						<xsl:value-of select="rdf:RDF/skos:ConceptScheme/dc:title"/>
						</h1>
						<h2><xsl:value-of select="rdf:RDF/skos:ConceptScheme/dc:description"/></h2>
								<table>
										<xsl:for-each select="//skos:prefLabel | //skos:altLabel">
												<xsl:sort select="." order="ascending"/>
												<xsl:apply-templates select="."/>
										</xsl:for-each>
								</table>
						</body>
				</html>
		</xsl:template>
		<xsl:template match="skos:prefLabel">
				<tr class="UF">
						<td class="term"  style="border-top : solid black 1px" >
						 			<a>
						 			  <xsl:attribute name="name">
						 			   <xsl:value-of select="parent::skos:Concept/@rdf:about"/>
						 			  </xsl:attribute>
						 			</a>
								<span style="color:maroon">
								  <xsl:value-of select="."/>
								</span>
						</td>
						<td  style="border-top : solid black 1px">Används för (UF):</td>
						<td class="desc"  style="border-top : solid black 1px" >
								<xsl:for-each select="../skos:altLabel">
										<xsl:value-of select="."/>
										<br/>
								</xsl:for-each>
						</td>
				</tr>
				<xsl:if test="../skos:scopeNote">
						<tr class="SN">
								<td class="term">
										<xsl:text/>
								</td>
								<td>Notera (SN):</td>
								<td class="desc">
										<xsl:for-each select="../skos:scopeNote">
												<xsl:value-of select="."/>
												<br/>
										</xsl:for-each>
								</td>
						</tr>
				</xsl:if>
				<xsl:if test="../skos:broader">
						<tr class="BT">
								<td class="term" >
										<xsl:text/>
								</td>
								<td>Överordnade koncept (BT):</td>
								<td class="desc">
										<xsl:for-each select="../skos:broader">
												<xsl:call-template name="BaseNameResolver">
														<xsl:with-param name="namn">
																<xsl:value-of select="@rdf:resource"/>
														</xsl:with-param>
												</xsl:call-template>
												<br/>
										</xsl:for-each>
								</td>
						</tr>
				</xsl:if>
				<xsl:if test="../skos:narrower">
						<tr class="NT">
								<td class="term">
										<xsl:text/>
								</td>
								<td>Underordnade koncept (NT):</td>
								<td class="desc">
										<xsl:for-each select="../skos:narrower">
												<xsl:call-template name="BaseNameResolver">
														<xsl:with-param name="namn">
																<xsl:value-of select="@rdf:resource"/>
														</xsl:with-param>
												</xsl:call-template>
												<br/>
										</xsl:for-each>
								</td>
						</tr>
				</xsl:if>
				<xsl:if test="../skos:related">
						<tr class="RT">
								<td class="term">
										<xsl:text/>
								</td>
								<td>Relaterade koncept (RT):</td>
								<td class="desc">
										<xsl:for-each select="../skos:related">
												<xsl:call-template name="BaseNameResolver">
														<xsl:with-param name="namn">
																<xsl:value-of select="@rdf:resource"/>
														</xsl:with-param>
												</xsl:call-template>
												<br/>
										</xsl:for-each>
								</td>
						</tr>
				</xsl:if>
				<xsl:if test="../skos:definition">
						<tr class="DEF">
								<td class="term">
										<xsl:text/>
								</td>
								<td>Definieras som:</td>
								<td class="desc">
								  <xsl:value-of select="../skos:definition"/>
								</td>
						</tr>
				</xsl:if>
				<xsl:if test="../skos:example">
						<tr class="EX">
								<td class="term">
										<xsl:text/>
								</td>
								<td>Exempel:</td>
								<td class="desc">
								 <xsl:for-each select="../skos:example">
								  <a>
								    <xsl:attribute name="href">
								    <xsl:value-of select="@rdf:resource"/></xsl:attribute>
								    <xsl:value-of select="@rdf:resource"/>
								  </a>
								  <br/>
								  </xsl:for-each>
								</td>
						</tr>
				</xsl:if>
		</xsl:template>
		<xsl:template match="skos:altLabel">
				<tr class="USE">
						<td class="term"  style="text-indent : 1em; border-top : solid black 1px" >
								<span style="color:red">
										<xsl:value-of select="."/>
								</span> (icke föredragen term)</td>
						<td  style="border-top : solid black 1px" >Använd i stället (USE): </td>
						<td style="border-top : solid black 1px" class="desc">
								<xsl:value-of select="../skos:prefLabel"/>
						</td>
				</tr>
		</xsl:template>
		<xsl:template name="BaseNameResolver">
				<xsl:param name="namn">Unresolved</xsl:param>
				<xsl:for-each select="//skos:Concept[@rdf:about=$namn]">
						<a href="{$namn}">
						<xsl:value-of select="skos:prefLabel"/>
						</a>
				</xsl:for-each>
		</xsl:template>
</xsl:stylesheet>
