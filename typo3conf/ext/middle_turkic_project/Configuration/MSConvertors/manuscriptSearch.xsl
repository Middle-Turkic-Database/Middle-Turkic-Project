<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:mtdb="http://www.middleturkic.uu.se"
    xmlns:func="http://exslt.org/functions" xmlns:str="http://exslt.org/strings"
    xmlns:math="http://exslt.org/math" xmlns:common="http://exslt.org/common"
    exclude-result-prefixes="tei mtdb" extension-element-prefixes="func str math common" version="1.0">
    <xsl:import
        href="typo3conf/ext/middle_turkic_project/Configuration/MSConvertors/commonFunctions.xsl" />
    <xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes" />

    <xsl:variable name="traverseType">
        <xsl:text>verse-by-verse</xsl:text>
    </xsl:variable>

    <!-- External parameter -->
    <xsl:param name="pageNo" select="'1'" />
    <xsl:param name="numResults" select="'10'" />

    <!-- Variables -->
    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
    <xsl:variable name="totalPages" select="ceiling(/results/count div $numResults)"/>

    <xsl:template match="/">
        <xsl:apply-templates />
        <xsl:call-template name="renderSearchPagination"/>
    </xsl:template>

    <xsl:template match="count">
        <xsl:choose>
            <xsl:when test=". = 0">
                No results found!
            </xsl:when>
            <xsl:otherwise>
                <div class="text-muted mb-3 small">
                    <xsl:text>Showing results </xsl:text>
                    <xsl:value-of select="($pageNo - 1) * $numResults + 1"/>
                    <xsl:text>-</xsl:text>
                    <xsl:choose>
                        <xsl:when test="$pageNo * $numResults &gt; .">
                            <xsl:value-of select="."/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$pageNo * $numResults"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text> of </xsl:text>
                    <xsl:value-of select="."/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="result">
        <xsl:variable name="href">
            <xsl:text>/manuscripts</xsl:text>
            <xsl:value-of select="./@slug" />
            <xsl:if test="./@manuscriptName">
                <xsl:text>/</xsl:text>
                <xsl:value-of select="./@manuscriptName" />
                <xsl:text>/</xsl:text>
                <xsl:choose>
                    <xsl:when test="./@docType">
                        <xsl:value-of select="translate(./@docType, $uppercase, $lowercase)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>description</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="./@bookNo">
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="./@bookNo" />
                    <xsl:if test="./@chapterNo">
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="./@chapterNo" />
                    </xsl:if>
                </xsl:if>
            </xsl:if>
        </xsl:variable>
        <a class="card mb-2" href="{$href}" target="_blank">
            <div class="card-header py-2">
                <xsl:if test="./@msSetName">
                    <xsl:value-of select="./@msSetName" />
                    <br />
                </xsl:if>
                <xsl:value-of select="./@manuscriptName" />
                <xsl:if test="./@docType">
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="./@docType" />
                </xsl:if>
            </div>
            <div class="card-body">
                <h5 class="card-title">
                    <xsl:apply-templates select="./summary" />
                    <xsl:if test="./@chapterFullName">
                        <xsl:text> - </xsl:text>
                        <xsl:value-of select="./@chapterFullName" />
                    </xsl:if>
                </h5>
                <p class="card-text text-dark">
                    <xsl:apply-templates select="./content" />
                </p>
            </div>
        </a>
    </xsl:template>

    <xsl:template match="summary">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="content">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="tei:mark">
        <mark>
            <xsl:apply-templates />
        </mark>
    </xsl:template>

    <xsl:template match="tei:ref" />
    
    <xsl:template name="renderSearchPagination">
        <xsl:if test="number($totalPages) &gt; 1">
            <nav id="searchPaginationNav" aria-label="Page navigation search">
                <ul class="pagination pagination-circle pg-red justify-content-center d-flex flex-wrap">
                    <xsl:element name="li">
                        <xsl:attribute name="class">
                            <xsl:text>page-item</xsl:text>
                            <xsl:if test="$pageNo = '1'">
                                <xsl:text> disabled</xsl:text>
                            </xsl:if>
                        </xsl:attribute>
                        <a class="page-link" href="#" title="First" aria-label="First" data-target="first">
                            <span aria-hidden="true">&#171;</span>
                            <span class="sr-only">First</span>
                        </a>
                    </xsl:element>
                    <xsl:element name="li">
                        <xsl:attribute name="class">
                            <xsl:text>page-item</xsl:text>
                            <xsl:if test="$pageNo = '1'">
                                <xsl:text> disabled</xsl:text>
                            </xsl:if>
                        </xsl:attribute>
                        <a class="page-link" href="#" title="Previous" aria-label="Previous" data-target="previous">
                            <span aria-hidden="true">&#8249;</span>
                            <span class="sr-only">Previous</span>
                        </a>
                    </xsl:element>
                    <xsl:if test="$pageNo > 3 and $totalPages - $pageNo > 1">
                        <li class="page-item">
                            <a class="page-link" href="#" title="Previous 5 pages" aria-label="Previous 5 pages" data-target="previousset">
                                <xsl:text>...</xsl:text>
                            </a>
                        </li>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="$pageNo - 2 &lt; 1 or $totalPages &lt;= 5">
                            <xsl:call-template name="renderPaginationPages">
                                <xsl:with-param name="currentPage" select="1" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$totalPages - $pageNo > 1">
                            <xsl:call-template name="renderPaginationPages">
                                <xsl:with-param name="currentPage" select="$pageNo - 2" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="renderPaginationPages">
                                <xsl:with-param name="currentPage" select="$totalPages - 4" />
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$totalPages - $pageNo > 2 and $totalPages > 5">
                        <li class="page-item">
                            <a class="page-link" href="#" title="Next 5 pages" aria-label="Next 5 pages" data-target="nextset">
                                <xsl:text>...</xsl:text>
                            </a>
                        </li>
                    </xsl:if>
                    <xsl:element name="li">
                        <xsl:attribute name="class">
                            <xsl:text>page-item</xsl:text>
                            <xsl:if test="$pageNo = $totalPages">
                                <xsl:text> disabled</xsl:text>
                            </xsl:if>
                        </xsl:attribute>
                    </xsl:element>
                    <xsl:element name="li">
                        <xsl:attribute name="class">
                            <xsl:text>page-item</xsl:text>
                            <xsl:if test="$pageNo = $totalPages">
                                <xsl:text> disabled</xsl:text>
                            </xsl:if>
                        </xsl:attribute>
                        <a class="page-link" href="#" title="Next" aria-label="Next" data-target="next">
                            <span aria-hidden="true">&#8250;</span>
                            <span class="sr-only">Next</span>
                        </a>
                    </xsl:element>
                    <xsl:element name="li">
                        <xsl:attribute name="class">
                            <xsl:text>page-item</xsl:text>
                            <xsl:if test="$pageNo = $totalPages">
                                <xsl:text> disabled</xsl:text>
                            </xsl:if>
                        </xsl:attribute>
                        <a class="page-link" href="#" title="Last" aria-label="Last" data-target="last">
                            <span aria-hidden="true">&#187;</span>
                            <span class="sr-only">Last</span>
                        </a>
                    </xsl:element>
                </ul>
            </nav>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="renderPaginationPages">
        <xsl:param name="currentPage" select="1" />
        <xsl:param name="iterator" select="1" />
        <xsl:if test="$iterator &lt;= 5 and $currentPage &lt;= $totalPages">
            <xsl:element name="li">
                <xsl:attribute name="class">
                    <xsl:text>page-item</xsl:text>
                    <xsl:if test="$currentPage = $pageNo">
                        <xsl:text> active</xsl:text>
                    </xsl:if>
                </xsl:attribute>
                <a class="page-link" href="#" data-target="{$currentPage}">
                    <xsl:value-of select="$currentPage" />
                </a>
            </xsl:element>
            <xsl:call-template name="renderPaginationPages">
                <xsl:with-param name="currentPage" select="$currentPage + 1" />
                <xsl:with-param name="iterator" select="$iterator + 1"></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
