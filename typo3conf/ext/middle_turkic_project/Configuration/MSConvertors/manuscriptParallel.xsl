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
    <xsl:variable name="translationDoc" select="document(str:encode-uri($translationPath, true()))"/>

    <xsl:template match="tei:l">
        <tr>
            <td class="align-text-top five-percent-width">
                <xsl:if test="./@n">
                    <xsl:text>[</xsl:text>
                    <xsl:value-of select="./@n"/>
                    <xsl:text>]</xsl:text>
                </xsl:if>
            </td>
            <td class="fortysevenandhalf-percent-width pr-4">
                <xsl:apply-templates select="key('betweenLineText', generate-id())"/>
                <xsl:apply-templates/>
            </td>
            <td class="fortysevenandhalf-percent-width pr-3">
                <xsl:variable name="abPosition" select="count(../preceding-sibling::tei:ab) + 1"/>
                <xsl:variable name="lPosition" select="position()"/>
                <xsl:for-each select="$translationDoc">
                    <xsl:apply-templates
                        select="key('betweenLineText', generate-id($translationDoc/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']/tei:div[@type = 'textpart']/tei:ab[$abPosition]/tei:l[$lPosition]))"
                    />
                </xsl:for-each>
                <xsl:apply-templates
                    select="$translationDoc/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']/tei:div[@type = 'textpart']/tei:ab[$abPosition]/tei:l[$lPosition]/node()"
                />
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
