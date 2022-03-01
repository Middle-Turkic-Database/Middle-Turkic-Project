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
    
    <xsl:template match="tei:lg">
        <tr>
            <td class="align-text-top seven-percent-width">
                <xsl:if test="count(./tei:l[@n]) > 0">
                    <xsl:text>[</xsl:text>
                    <xsl:value-of select="./tei:l[@n][1]/@n"/>
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="./tei:l[@n][last()]/@n"/>
                    <xsl:text>]</xsl:text>
                </xsl:if>
            </td>
            <td class="fortysixandhalf-percent-width pr-4">
                <xsl:for-each select="./tei:l">
                    <xsl:apply-templates select="key('betweenLineText', generate-id())" />
                    <xsl:apply-templates />
                </xsl:for-each>
            </td>
            <td class="fortysixandhalf-percent-width pr-3">
                <xsl:variable name="abPosition" select="count(../preceding-sibling::tei:ab) + 1"/>
                <xsl:variable name="lgPosition" select="position()"/>
                <xsl:for-each select="($translationAbPart[$abPosition]/tei:l|$translationAbPart[$abPosition]/tei:lg)[$lgPosition]/tei:l">
                    <xsl:apply-templates select="key('betweenLineText', generate-id())" />
                    <xsl:apply-templates />
                    <xsl:text> </xsl:text>
                </xsl:for-each>
            </td>
        </tr>
    </xsl:template>
    
    <xsl:template match="tei:l">
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
                <xsl:if test="./@n">
                    <xsl:text>[</xsl:text>
                    <xsl:value-of select="./@n"/>
                    <xsl:text>]</xsl:text>
                </xsl:if>
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
                <xsl:apply-templates select="key('betweenLineText', generate-id())"/>
                <xsl:apply-templates/>
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
                <xsl:variable name="abPosition" select="count(../preceding-sibling::tei:ab) + 1"/>
                <xsl:variable name="lPosition" select="position()"/>
                <xsl:variable name="translationVerse" select="($translationAbPart[$abPosition]/tei:l|$translationAbPart[$abPosition]/tei:lg)[$lPosition]"/>
                <xsl:for-each select="$translationVerse">
                    <xsl:apply-templates
                        select="key('betweenLineText', generate-id($translationVerse))"
                    />
                </xsl:for-each>
                <xsl:apply-templates
                    select="$translationVerse/node()"
                />
            </xsl:element>
        </tr>
    </xsl:template>
</xsl:stylesheet>
