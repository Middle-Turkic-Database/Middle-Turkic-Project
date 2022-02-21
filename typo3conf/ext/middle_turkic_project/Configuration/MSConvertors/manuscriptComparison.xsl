<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:str="http://exslt.org/strings"
    exclude-result-prefixes="tei" extension-element-prefixes="str">
    <xsl:import
        href="typo3conf/ext/middle_turkic_project/Configuration/MSConvertors/commonFunctions.xsl"/>
    <xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- External parameter -->
    <xsl:param name="manuscript1Name" select="''" />
    <xsl:param name="manuscript2Name" select="''" />
    <xsl:param name="manuscript2FullPath" select="''"/>
    
    <!-- Fetch second manuscript document -->
    <xsl:variable name="secondManuscript" select="document(str:encode-uri($manuscript2FullPath, true()))"/>
    <xsl:variable name="secondManusciprtABPart" select="$secondManuscript/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']/tei:div[@type = 'textpart']/tei:ab" />
    
    <!-- Variables -->
    
    <xsl:variable name="traverseType" select="'verse-by-verse'"/>
    <xsl:variable name="stripedTable" select="true()"/>
    
    <!-- End of Variables -->
    
    <xsl:template match="/">
        <xsl:apply-templates
            select="/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']/tei:div[@type = 'textpart']"
        />
    </xsl:template>
    
    <xsl:template match="tei:div[@type = 'textpart']">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:ab">
        <div class="row mx-0">
            <xsl:element name="table">
                <xsl:attribute name="id">
                    <xsl:text>msComparisonTable</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="class">
                    <xsl:text>table table-borderless table-sm table-striped</xsl:text>
                </xsl:attribute>
                <thead>
                    <tr>
                        <td class="align-text-top five-percent-width">#</td>
                        <td class="fortyfive-percent-width pr-4">
                            <xsl:value-of select="$manuscript1Name"/>
                        </td>
                        <td class="align-text-top five-percent-width">#</td>
                        <td class="fortyfive-percent-width pr-3">
                            <xsl:value-of select="$manuscript2Name"/>
                        </td>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="align-text-top five-percent-width" />
                        <td class="fortyfive-percent-width pr-4">
                            <xsl:apply-templates select="tei:title" />
                        </td>
                        <td class="align-text-top five-percent-width" />
                        <td class="fortyfive-percent-width pr-3">
                            <xsl:apply-templates select="$secondManusciprtABPart/tei:title" />
                        </td>
                    </tr>
                    <xsl:apply-templates select="tei:l" />
                </tbody>
            </xsl:element>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:l">
        <xsl:variable name="xml-id" select="./@xml:id"/>
        <!-- If there is an opening verse in right manuscript which does not exist
             in the left manuscript and viceversa -->
        <xsl:if test="position() = 1">
            <xsl:if test="not(@n = $secondManusciprtABPart/tei:l[1]/@n)">
                <tr>
                    <td class="align-text-top five-percent-width" />
                    <td class="fortyfive-percent-width pr-4 left-column">
                        <xsl:if test="not(@n)">
                            <xsl:apply-templates select="key('betweenLineText', generate-id())"/>
                            <xsl:apply-templates/>
                        </xsl:if>
                    </td>
                    <td class="align-text-top five-percent-width" />
                    <td class="fortyfive-percent-width pr-3 right-column">
                        <xsl:if test="@n">
                            <!-- Using foreach loop to change context to the second document -->
                            <xsl:for-each select="$secondManusciprtABPart">
                                <xsl:apply-templates
                                    select="key('betweenLineText', generate-id(.//tei:l[position() = 1]))"
                                />
                            </xsl:for-each>
                            <xsl:apply-templates select="$secondManusciprtABPart/tei:l[1]/node()" />
                        </xsl:if>
                    </td>
                </tr>
            </xsl:if>
        </xsl:if>
        <xsl:if test="not(position() = 1) or @n = $secondManusciprtABPart/tei:l[1]/@n or @n">
            <tr>
                <td class="align-text-top five-percent-width">
                    <xsl:if test="./@n">
                        <xsl:text>[</xsl:text>
                        <xsl:value-of select="./@n"/>
                        <xsl:text>]</xsl:text>
                    </xsl:if>
                </td>
                <td class="fortyfive-percent-width pr-4 left-column">
                    <xsl:apply-templates select="key('betweenLineText', generate-id())"/>
                    <xsl:apply-templates/>
                </td>
                <td class="align-text-top five-percent-width">
                    <xsl:if test="$secondManusciprtABPart/tei:l[@xml:id=$xml-id]/@n">
                        <xsl:text>[</xsl:text>
                        <xsl:value-of select="$secondManusciprtABPart/tei:l[@xml:id=$xml-id]/@n" />
                        <xsl:text>]</xsl:text>
                    </xsl:if>
                </td>
                <td class="fortyfive-percent-width pr-3 right-column">
                    <xsl:if test="$secondManusciprtABPart/tei:l[@xml:id=$xml-id]">
                        <!-- Using foreach loop to change context to the second document -->
                        <xsl:for-each select="$secondManusciprtABPart">
                            <xsl:apply-templates select="key('betweenLineText', generate-id(.//tei:l[@xml:id=$xml-id]))" />
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:apply-templates select="$secondManusciprtABPart/tei:l[@xml:id=$xml-id]/node()" />
                </td>
            </tr>
        </xsl:if>
        
        
        <!-- If there is an ending verse in right manuscript which does not exist
             in the left manuscript -->
        <xsl:if test="position() = last()">
            <xsl:for-each select="$secondManusciprtABPart/tei:l[@xml:id = $xml-id]/following-sibling::tei:l">
                <tr>
                    <td class="align-text-top five-percent-width" />
                    <td class="fortyfive-percent-width pre-4 left-column" />
                    <td class="align-text-top five-percent-width">
                        <xsl:if test="./@n">
                            <xsl:text>[</xsl:text>
                            <xsl:value-of select="./@n" />
                            <xsl:text>]</xsl:text>
                        </xsl:if>
                    </td>
                    <td class="fortyfive-percent-width pre-3 right-column">
                        <xsl:apply-templates select="key('betweenLineText', generate-id(.))" />
                        <xsl:apply-templates select="./node()" />
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:milestone[@unit = 'line']">
    </xsl:template>
    
    <xsl:template match="tei:foreign">
        <xsl:apply-templates />
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:ref">
    </xsl:template>
    
    <xsl:template match="tei:supplied[@reason = 'lost']">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="tei:emph">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="tei:addSpan">
    </xsl:template>
    
    <xsl:template match="tei:anchor[starts-with(@xml:id, 'add')]">
    </xsl:template>
    
    <xsl:template match="tei:delSpan">
    </xsl:template>
    
    <xsl:template match="tei:anchor[starts-with(@xml:id, 'del')]">
    </xsl:template>
    
    <xsl:template match="tei:seg[@type = 'commented']">
    </xsl:template>
    
    <xsl:template match="tei:anchor[@type = 'commented']">
    </xsl:template>
</xsl:stylesheet>