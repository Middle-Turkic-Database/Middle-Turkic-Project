<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:func="http://exslt.org/functions"
                xmlns:str="http://exslt.org/strings"
                xmlns:common="http://exslt.org/common" exclude-result-prefixes="tei" extension-element-prefixes="func str common">
   <xsl:import href="typo3conf/ext/middle_turkic_project/Configuration/MSConvertors/xml-to-string.xsl" />
   <xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes" />
   <xsl:strip-space elements="*" />

   <!-- External parameter -->
   <xsl:param name="translationPath" select="''" />
   
   <!-- Variables -->
   
   <!-- End of Variables -->
   
   <!-- Text extractor for the text between lines -->
   <xsl:key name="betweenLineText" match="//tei:div[@type='textpart']//node()[not(ancestor-or-self::tei:l)][not(parent::tei:foreign)][not(parent::tei:ref)]" use="generate-id(following::tei:l[1])" />
   
   <!-- Extracts footnote with respect to its xml:id -->
   <xsl:key name="footnote" match="/tei:TEI/tei:text/tei:body/tei:div[@type='apparatus']/tei:listApp/tei:app/tei:note" use="@xml:id" />

   <!-- Fetch manuscript translation document -->
   <xsl:variable name="translationDoc" select="document(str:encode-uri($translationPath, true()))" />
   
   <xsl:template match="/">
      <xsl:apply-templates select="/tei:TEI/tei:text/tei:body/tei:div[@type='edition']/tei:div[@type='textpart']" />
   </xsl:template>
   
   <xsl:template match="tei:div[@type='textpart']">
      <xsl:apply-templates />
   </xsl:template>
   
   <xsl:template match="tei:ab">
   <div class="container">
      <div class="row">
         <table class="table table-borderless table-sm table-striped"><xsl:apply-templates select="tei:l"/></table>
      </div>
   </div>
   </xsl:template>

   <xsl:template match="tei:milestone[@unit='page']">
      <xsl:text>(</xsl:text>
      <xsl:value-of select="@n" />
      <xsl:text>)</xsl:text>
   </xsl:template>

   <xsl:template match="tei:l">
      <tr>
         <td class="align-text-top five-percent-width">
            <xsl:if test="./@n">
               [<xsl:value-of select="./@n" />]
            </xsl:if>
         </td>
         <td class="fortysevenandhalf-percent-width pr-4">
            <xsl:apply-templates select="key('betweenLineText', generate-id())" />
            <xsl:apply-templates />
         </td>
         <td class="fortysevenandhalf-percent-width pr-3">
            <xsl:variable name="abPosition" select="count(../preceding-sibling::tei:ab) + 1" />
            <xsl:variable name="lPosition" select="position()" />
            <xsl:for-each select="$translationDoc">
               <xsl:apply-templates select="key('betweenLineText', generate-id($translationDoc/tei:TEI/tei:text/tei:body/tei:div[@type='edition']/tei:div[@type='textpart']/tei:ab[$abPosition]/tei:l[$lPosition]))" />
            </xsl:for-each>
            <xsl:apply-templates select="$translationDoc/tei:TEI/tei:text/tei:body/tei:div[@type='edition']/tei:div[@type='textpart']/tei:ab[$abPosition]/tei:l[$lPosition]/node()" />
         </td>
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
      <sup>   
         <xsl:element name="abbr">
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
                     <xsl:apply-templates select="key('footnote', substring(@target,2))" />
                  </div>
               </xsl:variable>
               <xsl:call-template name="xml-to-string">
                  <xsl:with-param name="node-set" select="common:node-set($footnoteContent)" />
               </xsl:call-template> 
            </xsl:attribute>
            <xsl:apply-templates />
         </xsl:element>
      </sup>
      <xsl:text> </xsl:text>
   </xsl:template>

   <xsl:template match="tei:emph">
      <em>
         <xsl:apply-templates />
      </em>
   </xsl:template>
</xsl:stylesheet>
