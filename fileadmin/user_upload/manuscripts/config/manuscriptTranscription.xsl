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
      <table><xsl:apply-templates /></table>
   </xsl:template>
   
   <xsl:template match="tei:locus">
      <tr>
         <td class="pt-3">
            <h5><xsl:apply-templates /></h5>
         </td>
      </tr>
   </xsl:template>

   <xsl:template match="tei:l">
      <tr>
         <td class="align-text-top" style="width: 10%;">(<xsl:value-of select="./@n" />)</td>
         <td><xsl:apply-templates /></td>
      </tr>
   </xsl:template>

   <xsl:template match="tei:foreign">
      <xsl:element name="span">
         <xsl:attribute name="style">
            <xsl:value-of select="./@style" />
         </xsl:attribute>
         <xsl:apply-templates />
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
