<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:common="http://exslt.org/common"
    exclude-result-prefixes="tei" extension-element-prefixes="common">
    <xsl:import href="xml-to-string.xsl"/>

    <!-- Variables -->

    <xsl:param name="traverseType" select="'verse-by-verse'"/>
    <xsl:param name="stripedTable" select="false()"/>

    <!-- End of Variables -->

    <!-- Text extractor for the milestone self closing tag -->
    <xsl:key name="transText"
        match="//tei:div[@type = 'textpart']//node()[not(parent::tei:supplied)][not(self::tei:milestone)][not(parent::tei:foreign)][not(parent::tei:ref)][not(parent::tei:emph)]"
        use="generate-id(preceding::tei:milestone[1])"/>
    
    <!-- Text extractor for the first continued line from the last section (no milestone-page exists at the beginning) -->
    <xsl:key name="continuedLineText"
        match="//tei:div[@type = 'textpart']//node()[not(parent::tei:supplied)][not(self::tei:milestone)][not(parent::tei:foreign)][not(parent::tei:ref)][not(parent::tei:emph)][not(self::tei:l)][not(ancestor-or-self::tei:title)]"
        use="generate-id(following::tei:milestone[1])"/>

    <!-- Text extractor for the text between lines -->
    <xsl:key name="betweenLineText"
        match="//tei:div[@type = 'textpart']//node()[not(ancestor-or-self::tei:l)][not(parent::tei:foreign)][not(parent::tei:ref)][not(ancestor-or-self::tei:title)]"
        use="generate-id(following::tei:l[1])"/>

    <!-- Extracts footnote with respect to its xml:id -->
    <xsl:key name="footnote"
        match="/tei:TEI/tei:text/tei:body/tei:div[@type = 'apparatus']/tei:listApp/tei:app/tei:note"
        use="@xml:id"/>

    <xsl:template match="/">
        <xsl:apply-templates
            select="/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']/tei:div[@type = 'textpart']"
        />
    </xsl:template>

    <xsl:template match="tei:div[@type = 'textpart']">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:ab">
        <div class="container">
            <div class="row">
                <h5 class="mb-3">
                    <xsl:apply-templates select="tei:title"/>
                </h5>
                <xsl:element name="table">
                    <xsl:attribute name="class">
                        <xsl:text>table table-borderless table-sm</xsl:text>
                        <xsl:if test="$stripedTable = true()">
                            <xsl:text> table-striped</xsl:text>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$traverseType = 'verse-by-verse'">
                            <xsl:apply-templates select="tei:l"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="//tei:milestone"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:milestone[@unit = 'page']">
        <xsl:choose>
            <xsl:when test="$traverseType = 'verse-by-verse'">
                <xsl:call-template name="milestone-page-verse-by-verse"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="milestone-page-line-by-line"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="milestone-page-verse-by-verse">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>)</xsl:text>
        <xsl:variable name="firstFSiblingName" select="local-name(following-sibling::node()[1])"/>
        <xsl:if test="not($firstFSiblingName = 'ref')">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template name="milestone-page-line-by-line">
        <tr>
            <td class="pt-3" colspan="2">
                <h5>
                    <xsl:value-of select="./@n"/>
                    <xsl:apply-templates select="key('transText', generate-id())"/>
                </h5>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="tei:milestone[@unit = 'line']">
        <xsl:choose>
            <xsl:when test="$traverseType = 'line-by-line'">
                <xsl:call-template name="milestone-line-line-by-line"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="milestone-line-verse-by-verse"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="milestone-line-verse-by-verse">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>)</xsl:text>
        <xsl:variable name="firstFSiblingName" select="local-name(following-sibling::node()[1])"/>
        <xsl:if test="not($firstFSiblingName = 'ref')">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template name="milestone-line-line-by-line">
        <xsl:variable name="continuedLineText" select="key('continuedLineText', generate-id())"/>
        <!-- If there is a continued line from previous section -->
        <xsl:if test="position() = 1 and $continuedLineText != ''">
            <tr>
                <td class="align-text-top five-percent-width"></td>
                <td>
                    <xsl:for-each select="$continuedLineText">
                        <!-- If the element is the first child of the upper l element and l has an n attribute -->
                        <xsl:if test="node() = parent::node()/node()[1] and parent::node()/@n">
                            <xsl:text> [</xsl:text>
                            <xsl:value-of select="parent::node()/@n"/>
                            <xsl:text>] </xsl:text>
                        </xsl:if>
                        <xsl:apply-templates select="." />
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
        <tr>
            <td class="align-text-top five-percent-width">
                <xsl:text>(</xsl:text>
                <xsl:value-of select="./@n"/>
                <xsl:text>)</xsl:text>
            </td>
            <td>
                <xsl:apply-templates select="key('transText', generate-id())"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="tei:l">
        <xsl:choose>
            <xsl:when test="$traverseType = 'line-by-line'">
                <xsl:call-template name="l-line-by-line"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="l-verse-by-verse"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="l-verse-by-verse">
        <tr>
            <td class="align-text-top five-percent-width">
                <xsl:if test="./@n">
                    <xsl:text> [</xsl:text>
                    <xsl:value-of select="./@n"/>
                    <xsl:text>] </xsl:text>
                </xsl:if>
            </td>
            <td>
                <xsl:apply-templates select="key('betweenLineText', generate-id())"/>
                <xsl:apply-templates/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template name="l-line-by-line">
        <xsl:if test="./@n">
            <xsl:text> [</xsl:text>
            <xsl:value-of select="./@n"/>
            <xsl:text>] </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:foreign">
        <xsl:element name="span">
            <xsl:attribute name="style">
                <xsl:value-of select="./@style"/>
            </xsl:attribute>
            <xsl:apply-templates/>
            <xsl:text> </xsl:text>
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
                            <xsl:apply-templates select="key('footnote', substring(@target, 2))"/>
                        </div>
                    </xsl:variable>
                    <xsl:call-template name="xml-to-string">
                        <xsl:with-param name="node-set" select="common:node-set($footnoteContent)"/>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:value-of select="substring(@target, 4)"/>
            </xsl:element>
        </sup>
        <xsl:variable name="firstFSiblingName" select="local-name(following-sibling::*[1])"/>
        <xsl:if test="
                $firstFSiblingName = 'supplied' or
                $firstFSiblingName = 'addSpan' or
                $firstFSiblingName = 'delSpan' or
                $firstFSiblingName = 'milestone'">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:gap[@reason = 'lost']">
        <xsl:text> […]</xsl:text>
    </xsl:template>

    <xsl:template match="tei:supplied[@reason = 'lost']">
        <xsl:variable name="firstPSiblingText" select="preceding-sibling::node()[1]"/>
        <!-- Add a space if the last character is a period. -->
        <xsl:if test="substring($firstPSiblingText, string-length($firstPSiblingText), 1) = '.'">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$traverseType = 'verse-by-verse'">
                <xsl:call-template name="supplied-lost-verse-by-verse"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="supplied-lost-line-by-line"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="supplied-lost-verse-by-verse">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template name="supplied-lost-line-by-line">
        <xsl:variable name="firstPSiblingName" select="local-name(preceding-sibling::node()[1])"/>
        <xsl:variable name="firstPSiblingUnit" select="preceding-sibling::node()[1]/@unit"/>
        <xsl:variable name="secondPSiblingName" select="local-name(preceding-sibling::node()[2])"/>
        <xsl:variable name="secondPSiblingUnit" select="preceding-sibling::node()[2]/@unit"/>
        <xsl:variable name="thirdPSiblingName" select="local-name(preceding-sibling::node()[3])"/>
        <xsl:if test="
                not(($firstPSiblingName = 'milestone' and $firstPSiblingUnit = 'line') or
                $firstPSiblingName = 'supplied') or
                (($firstPSiblingName = 'milestone' and $firstPSiblingUnit = 'line') and
                not(($secondPSiblingName = 'milestone' and $secondPSiblingUnit = 'page') or
                $secondPSiblingName = 'supplied')) or
                (($firstPSiblingName = 'milestone' and $firstPSiblingUnit = 'line')
                and ($secondPSiblingName = 'milestone' and $secondPSiblingUnit = 'page') and
                not($thirdPSiblingName = 'supplied'))">
            <xsl:text>[</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:variable name="firstFSiblingName" select="local-name(following-sibling::node()[1])"/>
        <xsl:variable name="firstFSiblingUnit" select="following-sibling::node()[1]/@unit"/>
        <xsl:variable name="secondFSiblingName" select="local-name(following-sibling::node()[2])"/>
        <xsl:variable name="secondFSiblingUnit" select="following-sibling::node()[2]/@unit"/>
        <xsl:variable name="thirdFSiblingName" select="local-name(following-sibling::node()[3])"/>
        <xsl:if test="
                not(($firstFSiblingName = 'milestone' and $firstFSiblingUnit = 'line') or
                ($firstFSiblingName = 'milestone' and $firstFSiblingUnit = 'page') or
                $firstFSiblingName = 'supplied') or
                (($firstFSiblingName = 'milestone' and
                $firstFSiblingUnit = 'line') and
                not($secondFSiblingName = 'supplied')) or
                (($firstFSiblingName = 'milestone' and $firstFSiblingUnit = 'page') and
                ($secondFSiblingName = 'milestone' and $secondFSiblingUnit = 'line') and
                not($thirdFSiblingName = 'supplied'))">
            <xsl:text>]</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:emph">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <xsl:template match="tei:addSpan">
        <xsl:text>{</xsl:text>
    </xsl:template>

    <xsl:template match="tei:anchor[starts-with(@xml:id, 'add')]">
        <xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="tei:delSpan">
        <xsl:text>&lt;</xsl:text>
    </xsl:template>

    <xsl:template match="tei:anchor[starts-with(@xml:id, 'del')]">
        <xsl:text>&gt;</xsl:text>
    </xsl:template>

    <xsl:template match="tei:seg[@type = 'commented']">
        <xsl:text> ⸢</xsl:text>
    </xsl:template>

    <xsl:template match="tei:anchor[@type = 'commented']">
        <xsl:text>⸣</xsl:text>
    </xsl:template>



</xsl:stylesheet>
