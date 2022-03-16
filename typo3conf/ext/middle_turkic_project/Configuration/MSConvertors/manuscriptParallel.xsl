<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:str="http://exslt.org/strings"
    exclude-result-prefixes="tei" extension-element-prefixes="str">
    <xsl:import
        href="typo3conf/ext/middle_turkic_project/Configuration/MSConvertors/commonFunctions.xsl"/>
    <xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- External parameter -->
    <xsl:param name="translationPath" select="''"/>

    <!-- Variables -->

    <xsl:variable name="traverseType" select="'verse-by-verse'"/>
    <xsl:variable name="stripedTable" select="true()"/>

    <!-- End of Variables -->

    <!-- Fetch manuscript translation document -->
    <xsl:variable name="translationAbPart" select="document(str:encode-uri($translationPath, true()))/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']/tei:div[@type = 'textpart']/tei:ab"/>
    
    <xsl:template match="tei:l | tei:lg">
        <tr>
            <td class="align-text-top index pr-2">
                <xsl:call-template name="renderVerseIndex" />
            </td>
            <td class="pr-3 w-50">
                <xsl:apply-templates mode="renderVerseContent" select="."/>
            </td>
            <td class="pr-3 w-50">
                <xsl:variable name="abPosition" select="count(../preceding-sibling::tei:ab) + 1"/>
                <xsl:variable name="l-lgPosition" select="position()"/>
                <xsl:variable name="elementName" select="name()" />
                    <xsl:choose>
                        <xsl:when test="$elementName = 'lg'">
                            <xsl:apply-templates mode="renderVerseContent" select="($translationAbPart[$abPosition]/tei:l|$translationAbPart[$abPosition]/tei:lg)[$l-lgPosition]" />
                        </xsl:when>
                        <xsl:when test="$elementName = 'l'">
                            <xsl:apply-templates mode="renderVerseContent" select="($translationAbPart[$abPosition]/tei:l|$translationAbPart[$abPosition]/tei:lg)[$l-lgPosition]" />
                        </xsl:when>
                    </xsl:choose>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
