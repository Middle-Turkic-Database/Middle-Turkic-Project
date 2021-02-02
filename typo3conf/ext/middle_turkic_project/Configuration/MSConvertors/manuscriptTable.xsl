<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">
   <xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes" />

   <!-- Variables -->      
   
   <!-- Line Break -->
         <xsl:variable name="newLine"><xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text></xsl:variable>

   <xsl:template match="/">
      <!-- Variables -->

      <!-- Shelf Number -->
      <xsl:variable name="shelfNo" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:idno" />

      <!-- End of Variables -->

      <td scope="col" class="pr-0">
         <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:idno"/>
      </td>
      <td scope="col">
         <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msContents/tei:summary" />
      </td>

      <td scope="col">
         <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:handDesc/tei:handNote[@scribe='copyist']" />  
      </td>
      <td scope="col">
         <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origDate" />
      </td>
      <td scope="col">
         <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:scriptDesc/tei:scriptNote" />
      </td>
   </xsl:template>

   <xsl:template match="tei:handNote">
      <p class="mb-2">
         <xsl:value-of select="." />
      </p>
   </xsl:template>

   <xsl:template match="tei:origDate">
      <p class="mb-2">
         <xsl:value-of select="." />
      </p>
</xsl:template>


</xsl:stylesheet>
