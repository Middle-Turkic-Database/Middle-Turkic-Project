<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:func="http://exslt.org/functions"
                xmlns:mtdb="http://www.middleturkic.uu.se" exclude-result-prefixes="tei mtdb" extension-element-prefixes="func">
   <xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes" />
   
   <!-- Variables -->
   
   <!-- Line Break -->
   <xsl:variable name="newLine">
      <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
   </xsl:variable>
   <!-- End of Variables -->
   
   
   <!-- Checks the Existance of an element -->
   <func:function name="mtdb:exists">
      <xsl:param name="element" />
      <func:result select="($element and not($element/@ana)) or ($element/@ana != '#no')" />
   </func:function>
   
   <xsl:template match="/">
      <xsl:apply-templates select="/tei:TEI/tei:text/tei:body/tei:div/tei:div[@type='textpart']" />
   </xsl:template>
   
   <xsl:template match="tei:div[@type='textpart']">
      <xsl:apply-templates />
   </xsl:template>
   
   <xsl:template match="tei:ab">
      <h5><xsl:apply-templates select="tei:locus"/></h5>
      <p><xsl:apply-templates select="*[not(self::tei:locus)]" /></p>
   </xsl:template>
   
   <xsl:template match="tei:locus">
      <xsl:apply-templates />
   </xsl:template>
   
   <xsl:template match="tei:l">
      <xsl:if test="@n > 1">
         <xsl:copy-of select="$newLine" />
      </xsl:if>
   </xsl:template>
</xsl:stylesheet>
