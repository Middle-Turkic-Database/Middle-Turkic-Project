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
            <xsl:element name="td">
                <xsl:attribute name="class">
                    <xsl:text>align-text-top</xsl:text>
                    <xsl:choose>
                        <xsl:when test="$translationAbPart/tei:lg">
                            <xsl:text> seven-percent-width</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> five-percent-width</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:call-template name="renderVerseIndex" />
            </xsl:element>
            <xsl:element name="td">
                <xsl:attribute name="class">
                    <xsl:text>pr-4</xsl:text>
                    <xsl:choose>
                        <xsl:when test="$translationAbPart/tei:lg">
                            <xsl:text> fortysixandhalf-percent-width</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> fortysevenandhalf-percent-width</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:call-template name="renderVerseContent" />
            </xsl:element>
            <xsl:element name="td">
                <xsl:attribute name="class">
                    <xsl:text>pr-3</xsl:text>
                    <xsl:choose>
                        <xsl:when test="$translationAbPart/tei:lg">
                            <xsl:text> fortysixandhalf-percent-width</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> fortysevenandhalf-percent-width</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <!-- Using for-each to change context -->
                <xsl:variable name="abPosition" select="count(../preceding-sibling::tei:ab) + 1"/>
                <xsl:variable name="l-lgPosition" select="position()"/>
                <xsl:variable name="elementName" select="name()" />
                <xsl:for-each select="$translationAbPart">
                    <xsl:choose>
                        <xsl:when test="$elementName = 'lg'">
                            <xsl:call-template name="renderVerseContent">
                                <xsl:with-param name="node" select="($translationAbPart[$abPosition]/tei:l|$translationAbPart[$abPosition]/tei:lg)[$l-lgPosition]" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$elementName = 'l'">
                            <xsl:call-template name="renderVerseContent">
                                <xsl:with-param name="node" select="($translationAbPart[$abPosition]/tei:l|$translationAbPart[$abPosition]/tei:lg)[$l-lgPosition]" />
                            </xsl:call-template>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:element>
        </tr>
    </xsl:template>
</xsl:stylesheet>
