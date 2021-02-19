<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:func="http://exslt.org/functions"
                xmlns:common="http://exslt.org/common"
                xmlns:mtdb="http://www.middleturkic.uu.se" exclude-result-prefixes="tei mtdb" extension-element-prefixes="func">
   <xsl:import href="typo3conf/ext/middle_turkic_project/Configuration/MSConvertors/xml-to-string.xsl" />
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

   <!-- Text extractor for the milestone[@unit='lb'] self closing tag -->
   <xsl:key name="transText" match="//tei:div[@type='textpart']//node()[not(self::tei:milestone)][not(self::tei:l)][not(parent::tei:foreign)][not(parent::tei:ref)]" use="generate-id(preceding::tei:milestone[@unit='lb'][1])" />

   <!-- Extracts footnote with respect to its xml:id -->
   <xsl:key name="footnote" match="/tei:TEI/tei:text/tei:body/tei:div[@type='apparatus']/tei:listApp/tei:app/tei:note" use="@xml:id" />
   
   <xsl:template match="/">   
      <xsl:apply-templates select="/tei:TEI/tei:text/tei:body/tei:div/tei:div[@type='textpart']" />
   </xsl:template>
   
   <xsl:template match="tei:div[@type='textpart']">
      <xsl:apply-templates />
   </xsl:template>
   
   <xsl:template match="tei:ab">
      <table><xsl:apply-templates select="//tei:milestone"/></table>
   </xsl:template>
   
   <xsl:template match="tei:milestone[@unit='pb']">
      <tr>
         <td class="pt-3">
            <h5><xsl:value-of select="./@n" /></h5>
         </td>
      </tr>
   </xsl:template>

   <xsl:template match="tei:milestone[@unit='lb']">
      <tr>
         <td class="align-text-top" style="width: 10%;">(<xsl:value-of select="./@n" />)</td>
         <td><xsl:apply-templates select="key('transText', generate-id())" /></td>
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

   <xsl:template match="tei:ref">      
      <xsl:element name="sup">
         <xsl:attribute name="class">
            <xsl:text>text-primary</xsl:text>
         </xsl:attribute>
         <xsl:attribute name="data-toggle">
            <xsl:text>tooltip</xsl:text>
         </xsl:attribute>
         <xsl:attribute name="data-placement">
            <xsl:text>top</xsl:text>
         </xsl:attribute>
         <xsl:attribute name="data-html">
            <xsl:text>true</xsl:text>
         </xsl:attribute>
         <xsl:attribute name="title">
            <xsl:variable name="footnoteContent">
               <div class="text-left">
                  <xsl:apply-templates select="key('footnote', @target)" />
               </div>
            </xsl:variable>
            <xsl:call-template name="xml-to-string">
               <xsl:with-param name="node-set" select="common:node-set($footnoteContent)" />
            </xsl:call-template> 
         </xsl:attribute>
         <xsl:apply-templates />
      </xsl:element>
   </xsl:template>

   <xsl:template match="tei:emph">
      <em>
         <xsl:apply-templates />
      </em>
   </xsl:template>
</xsl:stylesheet>
