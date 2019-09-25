<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:dc="http://purl.org/dc/elements/1.1/">
	<xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" media-type="application/xhtml+xml"/>
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>
					<xsl:value-of select="rdf:RDF/skos:ConceptScheme/dc:title"/>
				</title>
				<style type="text/css">
				  * {margin : 0}
				  body { margin : 3em 4em 3em 4em ;
				  font-family : Arial, sans-serif ;
				  font-size : 12pt
				  }
				  td {
				  vertical-align : top
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
				  h2 {
				  margin-bottom : 3em ;
				  border-bottom : 2px solid green
				  }
				</style>
			</head>
			<body>
				<h1>
					<xsl:value-of select="rdf:RDF/skos:ConceptScheme/dc:title"/>
				</h1>
				<h2>
					<xsl:value-of select="rdf:RDF/skos:ConceptScheme/dc:description"/> - hierarkisk vy
				</h2>

<div>
					<xsl:for-each select="//skos:prefLabel">
						<xsl:sort select="." order="ascending"/>
						<xsl:choose>
							<xsl:when
							test="parent::skos:Concept/skos:broader | parent::skos:Concept/skos:broaderTransitive"/>
							<xsl:otherwise>
								<xsl:apply-templates select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
			</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="skos:prefLabel">
		<div style="margin-left : 20px ; font-size : 1.3em">
			<xsl:value-of select="."/>
			<br/>
			<div style="margin-left : 20px">
				<xsl:for-each select="../skos:narrower | ../skos:narrowerTransitive">
					<xsl:call-template name="BaseNameResolver">
						<xsl:with-param name="namn">
							<xsl:value-of select="@rdf:resource"/>
						</xsl:with-param>
					</xsl:call-template>
					<br/>
				</xsl:for-each>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="BaseNameResolver">
		<xsl:param name="namn">Unresolved</xsl:param>
		<xsl:for-each select="//skos:Concept[@rdf:about=$namn]">
			<div style="margin-left : 20px" ><xsl:value-of select="skos:prefLabel"/>
			<br/>
			<xsl:if test="skos:narrower | skos:narrowerTransitive">
				<xsl:for-each select="skos:narrower | skos:narrowerTransitive">
					<xsl:call-template name="BaseNameResolver">
						<xsl:with-param name="namn">
							<xsl:value-of select="@rdf:resource"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
			</div>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
