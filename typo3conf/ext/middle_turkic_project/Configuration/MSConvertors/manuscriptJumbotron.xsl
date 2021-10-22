<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:func="http://exslt.org/functions"
    xmlns:mtdb="http://www.middleturkic.uu.se" exclude-result-prefixes="tei mtdb"
    extension-element-prefixes="func">
    <xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

    <!-- Variables -->

    <!-- End of Variables -->


    <!-- Checks the Existance of an element -->
    <func:function name="mtdb:exists">
        <xsl:param name="element"/>
        <func:result select="($element and not($element/@ana)) or ($element/@ana != '#no')"/>
    </func:function>

    <xsl:template match="/">
        <!-- Jumbotron -->
        <xsl:variable name="title"
            select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
        <xsl:variable name="author"
            select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>
        <xsl:variable name="summary"
            select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msContents/tei:summary"/>
        <xsl:variable name="shelfmark"
            select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:idno"/>

        <xsl:if test="mtdb:exists($title) or mtdb:exists($author) or mtdb:exists($summary)">
            <div class="jumbotron mx-1 mt-1">
                <xsl:if test="mtdb:exists($title)">
                    <h1 class="display-4">
                        <xsl:value-of select="$title"/>
                    </h1>
                </xsl:if>
                <xsl:if test="mtdb:exists($author)">
                    <p class="lead">
                     Author:
                     
                        
                        <xsl:value-of select="$author"/>
                    </p>
                </xsl:if>
                <xsl:if
                    test="mtdb:exists($summary) and (mtdb:exists($title) or mtdb:exists($author))">
                    <hr class="my-4"/>
                </xsl:if>
                <xsl:if test="mtdb:exists($summary)">
                    <h4>Summary</h4>
                    <p>
                        <xsl:if test="$shelfmark">
                            <xsl:value-of select="$shelfmark"/>
                            <xsl:text>: </xsl:text>
                        </xsl:if>
                        <span class="jumbotron-text">
                            <xsl:value-of select="$summary"/>
                        </span>
                    </p>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
