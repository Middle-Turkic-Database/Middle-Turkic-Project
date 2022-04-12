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
        match="//tei:div[@type = 'textpart']//node()[not(ancestor-or-self::tei:l)][not(ancestor-or-self::tei:lg)][not(parent::tei:foreign)][not(parent::tei:ref)][not(ancestor-or-self::tei:title)]"
        use="generate-id(following::tei:l[1])"/>

    <!-- Extracts footnote with respect to its xml:id -->
    <xsl:key name="footnote"
        match="/tei:TEI/tei:text/tei:body/tei:div[@type = 'apparatus']/tei:listApp/tei:app/tei:note"
        use="@xml:id"/>
    
    <!-- Renders verse number for l and lg elements -->
    <xsl:template name="renderVerseIndex">
        <xsl:param name="node" select="." />
        <xsl:choose>
            <xsl:when test="name() = 'l'">
                <xsl:if test="$node/@n">
                    <xsl:text>[</xsl:text>
                    <xsl:value-of select="$node/@n"/>
                    <xsl:text>]</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when test="name() = 'lg'">
                <xsl:if test="count($node/tei:l[@n]) > 0">
                    <xsl:if test="count($node/tei:l[@n]) > 0">
                        <xsl:text>[</xsl:text>
                        <xsl:value-of select="$node/tei:l[@n][1]/@n"/>
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="$node/tei:l[@n][last()]/@n"/>
                        <xsl:text>]</xsl:text>
                    </xsl:if>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- Renders verse content for l and lg elements -->
    <xsl:template match="tei:l|tei:lg" mode="renderVerseContent">
        <xsl:choose>
            <xsl:when test="name() = 'lg'">
                <xsl:call-template name="renderLgContent">
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="name() = 'l'">
                <xsl:call-template name="renderLContent">
                    <xsl:with-param name="node" select="." />
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- Renders verse content for lg elements -->
    <xsl:template name="renderLgContent">
        <xsl:param name="node" select="." />
        <xsl:for-each select="$node/tei:l">
            <xsl:call-template name="renderLContent" />
            <xsl:text> </xsl:text>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Renders verse content for l elements -->
    <xsl:template name="renderLContent">
        <xsl:param name="node" select="." />
        <xsl:apply-templates select="key('betweenLineText', generate-id($node))" />
        <xsl:apply-templates select="$node/node()" />
    </xsl:template>
    
    <!-- Render superscript -->
    <xsl:template name="renderSup">
        <xsl:param name="title" />
        <xsl:param name="value" />
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
                    <xsl:value-of select="$title"/>
                </xsl:attribute>
                <xsl:value-of select="$value"/>
            </xsl:element>
        </sup>
    </xsl:template>

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
                        <xsl:text>table table-borderless table-sm d-block</xsl:text>
                        <xsl:if test="$stripedTable = true()">
                            <xsl:text> table-striped</xsl:text>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$traverseType = 'verse-by-verse'">
                            <xsl:apply-templates select="tei:l | tei:lg"/>
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
        <tr>
            <xsl:if test="./@n">
                <td class="align-text-top index pr-2">
                    <xsl:text>(</xsl:text>
                    <xsl:if test="./@prev">
                        <xsl:text>…</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="./@n"/>
                    <xsl:if test="./@next">
                        <xsl:text>…</xsl:text>
                    </xsl:if>
                    <xsl:text>)</xsl:text>
                </td>
            </xsl:if>
            <xsl:element name="td">
                <xsl:if test="not(./@n)">
                    <xsl:attribute name="colspan">
                        <xsl:text>2</xsl:text>
                    </xsl:attribute>
                </xsl:if>
                <xsl:apply-templates select="key('transText', generate-id())"/>
            </xsl:element>
        </tr>
    </xsl:template>
    
    <xsl:template match="tei:lg">
        <xsl:choose>
            <xsl:when test="$traverseType = 'verse-by-verse'">
                <xsl:call-template name="lg-verse-by-verse" />
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="lg-verse-by-verse">
        <tr>
            <td class="align-text-top index pr-2">
                <xsl:call-template name="renderVerseIndex" />
            </td>
            <td>
                <xsl:apply-templates mode="renderVerseContent" select="." />
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
            <td class="align-text-top index pr-2">
                <xsl:call-template name="renderVerseIndex" />
            </td>
            <td>
                <xsl:apply-templates mode="renderVerseContent" select="." />
            </td>
        </tr>
    </xsl:template>

    <xsl:template name="l-line-by-line">
        <xsl:if test="./@n">
            <xsl:variable name="parent" select="local-name(parent::*)"/>
            <xsl:variable name="neighbor" select="local-name(preceding-sibling::*[1])"/>
            <xsl:variable name="neighbor-of-parent" select="local-name(parent::*/preceding-sibling::*[1])" />
            <xsl:if test="$neighbor = 'l' or
                            $neighbor = 'lg' or
                            $parent = 'lg' and
                                ($neighbor-of-parent = 'l' or
                                 $neighbor-of-parent = 'lg')">
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:text>[</xsl:text>
            <xsl:value-of select="./@n"/>
            <xsl:text>]</xsl:text>
                <xsl:text> </xsl:text>
            </xsl:if>
    </xsl:template>

    <xsl:template match="tei:foreign">
        <xsl:element name="span">
            <xsl:attribute name="style">
                <xsl:value-of select="./@style"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="tei:ref">
        <xsl:call-template name="renderSup">
            <xsl:with-param name="title">
                <xsl:variable name="footnoteContent">
                    <div class="text-left">
                        <xsl:apply-templates select="key('footnote', substring(@target, 2))"/>
                    </div>
                </xsl:variable>
                <xsl:call-template name="xml-to-string">
                    <xsl:with-param name="node-set" select="common:node-set($footnoteContent)"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="value">
                <xsl:value-of select="@n"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:variable name="firstFSiblingName" select="local-name(following-sibling::node()[1])"/>
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

    <xsl:template match="tei:anchor[@type='addSpan']">
        <xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="tei:delSpan">
        <xsl:text>&lt;</xsl:text>
    </xsl:template>

    <xsl:template match="tei:anchor[@type='delSpan']">
        <xsl:text>&gt;</xsl:text>
    </xsl:template>

    <xsl:template match="tei:seg[@type = 'commented']">
        <xsl:text> ⸢</xsl:text>
    </xsl:template>

    <xsl:template match="tei:anchor[@type = 'commented']">
        <xsl:text>⸣</xsl:text>
    </xsl:template>

    <xsl:template match="tei:space">
        <xsl:text> </xsl:text>
    </xsl:template>

</xsl:stylesheet>
