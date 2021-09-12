<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei">
    <xsl:import href="typo3conf/ext/middle_turkic_project/Configuration/MSConvertors/commonFunctions.xsl"/>
    <xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*" />
    
    <!-- Variables -->
    <xsl:variable name="traverseType">
        <xsl:choose>
            <xsl:when test="count(//tei:milestone[@unit='line']) &gt; 0">
                <xsl:text>line-by-line</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>verse-by-verse</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:variable>
    
    <!-- End of Variables -->
</xsl:stylesheet>
