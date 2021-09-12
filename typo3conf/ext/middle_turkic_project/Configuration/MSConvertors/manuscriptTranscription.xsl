<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!--    <xsl:import href="typo3conf/ext/middle_turkic_project/Configuration/MSConvertors/xml-to-string.xsl" />-->
    <xsl:import href="typo3conf/ext/middle_turkic_project/Configuration/MSConvertors/commonFunctions.xsl"/>
    <xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*"/>   
    
    <!-- Variables -->
    
    <xsl:variable name="traverseType" select="'line-by-line'"/>
    
    <!-- End of Variables -->
</xsl:stylesheet>
