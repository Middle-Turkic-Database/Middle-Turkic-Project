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
    <xsl:param name="prevMS1FullPath" select="''" />
    <xsl:param name="nextMS1FullPath" select="''" />
    <xsl:param name="prevMS2FullPath" select="''" />
    <xsl:param name="nextMS2FullPath" select="''" />
    
    <!-- Fetch second manuscript document -->
    <xsl:variable name="ms1AbPart" select="/tei:TEI/tei:text/tei:body/tei:div[@type='edition']/tei:div[@type='textpart']/tei:ab"/>
    
    <xsl:variable name="ms2" select="document(str:encode-uri($manuscript2FullPath, true()))"/>
    <xsl:variable name="ms2AbPart" select="$ms2/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']/tei:div[@type = 'textpart']/tei:ab" />
    
    <xsl:variable name="prevMs1" select="document(str:encode-uri($prevMS1FullPath, true()))"/>
    <xsl:variable name="prevMs1AbPart" select="$prevMs1/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']/tei:div[@type = 'textpart']/tei:ab"/>
    
    <xsl:variable name="prevMs2" select="document(str:encode-uri($prevMS2FullPath, true()))"/>
    <xsl:variable name="prevMs2AbPart" select="$prevMs2/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']/tei:div[@type = 'textpart']/tei:ab"/>
    
    <xsl:variable name="nextMs1" select="document(str:encode-uri($nextMS1FullPath, true()))"/>
    <xsl:variable name="nextMs1AbPart" select="$nextMs1/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']/tei:div[@type = 'textpart']/tei:ab"/>
    
    <xsl:variable name="nextMs2" select="document(str:encode-uri($nextMS2FullPath, true()))"/>
    <xsl:variable name="nextMs2AbPart" select="$nextMs2/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']/tei:div[@type = 'textpart']/tei:ab"/>
    
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
                    <xsl:text>table table-borderless table-sm table-striped d-block</xsl:text>
                </xsl:attribute>
                <thead>
                    <tr>
                        <td class="align-text-top index pr-2">#</td>
                        <td class="pr-3 w-50">
                            <xsl:value-of select="$manuscript1Name"/>
                        </td>
                        <td class="align-text-top index pr-2">#</td>
                        <td class="pr-3 w-50">
                            <xsl:value-of select="$manuscript2Name"/>
                        </td>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td />
                        <td class="pr-3">
                            <xsl:apply-templates select="tei:title" />
                        </td>
                        <td />
                        <td class="pr-3">
                            <xsl:apply-templates select="$ms2AbPart/tei:title" />
                        </td>
                    </tr>
                    <xsl:apply-templates select="tei:l | tei:lg" />
                </tbody>
            </xsl:element>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:l | tei:lg">
        <xsl:variable name="xml-id" select="./@xml:id"/>
        <xsl:variable name="ms2Verse" select = "($prevMs2AbPart/tei:l|
                                                $prevMs2AbPart/tei:lg|
                                                $ms2AbPart/tei:l|
                                                $ms2AbPart/tei:lg|
                                                $nextMs2AbPart/tei:l|
                                                $nextMs2AbPart/tei:lg)[@xml:id = $xml-id]" />
        <!-- If there is an opening verse in right manuscript which does not exist
             in the left one -->
        <xsl:if test="position() = 1 and not(($ms1AbPart/tei:l|$ms1AbPart/tei:lg)[@xml:id=($ms2AbPart/tei:l | $ms2AbPart/tei:lg)[1]/@xml:id])">
            <xsl:apply-templates select="($ms2AbPart/tei:l | $ms2AbPart/tei:lg)[1]" mode="missingLeftVerseStart" />
        </xsl:if>
        <tr>
            <td class="pr-2 index">
                <xsl:call-template name="renderVerseIndex" />
            </td>
            <td class="pr-3 w-50 left-column">
                <xsl:apply-templates mode="renderVerseContent" select="." />
            </td>
            <td class="pr-2 index">
                <xsl:call-template name="renderVerseIndex">
                    <xsl:with-param name="node" select="$ms2Verse" />
                </xsl:call-template>
                <xsl:if test="$ms2Verse/ancestor::tei:ab != $ms2AbPart">
                    <xsl:call-template name="renderSup">
                        <xsl:with-param name="title">
                            <xsl:apply-templates select="$ms2Verse/ancestor::tei:ab/tei:title" />
                        </xsl:with-param>
                        <xsl:with-param name="value">&#10013;</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </td>
            <td class="pr-3 w-50 right-column">
                <xsl:apply-templates mode="renderVerseContent" select="$ms2Verse" />
            </td>
        </tr>
        <!-- If there is an ending verse in right manuscript which does not exist
             in the left one -->
        <xsl:if test="position() = last() and not(($ms1AbPart/tei:l | $ms1AbPart/tei:lg)[@xml:id=($ms2AbPart/tei:l | $ms2AbPart/tei:lg)[last()]/@xml:id])">
            <xsl:apply-templates select="($ms2AbPart/tei:l | $ms2AbPart/tei:lg)[last()]" mode="missingLeftVerseEnd" />
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:l | tei:lg" mode="missingLeftVerseStart" >
        <xsl:variable name="xml-id" select="./@xml:id"/>
        <xsl:variable name="verseInPrevMs" select="($prevMs1AbPart/tei:l | $prevMs1AbPart/tei:lg)[@xml:id = $xml-id]"/>
        <tr>
            <td class="align-text-top pr-2 index">
                <xsl:if test="$verseInPrevMs">
                    <xsl:call-template name="renderVerseIndex">
                        <xsl:with-param name="node" select="($prevMs1AbPart/tei:l | $prevMs1AbPart/tei:lg)[@xml:id = $xml-id]" />
                    </xsl:call-template>
                    <xsl:call-template name="renderSup">
                        <xsl:with-param name="title">
                            <xsl:apply-templates select="$prevMs1AbPart/tei:title" />
                        </xsl:with-param>
                        <xsl:with-param name="value">&#10013;</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </td>
            <td class="pr-3 w-50 left-column">
                <xsl:apply-templates mode="renderVerseContent" select="$verseInPrevMs" />
            </td>
            <td class="align-text-top pr-2 index">
                <xsl:call-template name="renderVerseIndex" />
            </td>
            <td class="pr-3 w-50 right-column">
                <xsl:apply-templates mode="renderVerseContent" select="." />
            </td>
        </tr>
        <xsl:variable name="following-verse" select="(following-sibling::tei:l|following-sibling::tei:lg)[1]"/>
        <xsl:if test="not(($ms1AbPart/tei:l|$ms1AbPart/tei:lg)[@xml:id = $following-verse/@xml:id])">
            <xsl:apply-templates select="$following-verse" mode="missingLeftVerseStart" />
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:l | tei:lg" mode="missingLeftVerseEnd">
        <xsl:variable name="xml-id" select="./@xml:id" />
        <xsl:variable name="prevSiblingVerse" select="(preceding-sibling::tei:l | preceding-sibling::tei:lg)[last()]"/>
        <xsl:if test="not(($ms1AbPart/tei:l | $ms1AbPart/tei:lg)[@xml:id=$prevSiblingVerse/@xml:id])">
            <xsl:apply-templates select="$prevSiblingVerse" mode="missingLeftVerseEnd" />
        </xsl:if>
        <xsl:variable name="verseInNextMs" select="($nextMs1AbPart/tei:l | $nextMs1AbPart/tei:lg)[@xml:id=$xml-id]"/>
        <tr>
            <td class="pr-2 index">
                <xsl:if test="$verseInNextMs">
                    <xsl:call-template name="renderVerseIndex">
                        <xsl:with-param name="node" select="$verseInNextMs" />
                    </xsl:call-template>
                    <xsl:call-template name="renderSup">
                        <xsl:with-param name="title">
                            <xsl:apply-templates select="$nextMs1AbPart/tei:title" />
                        </xsl:with-param>
                        <xsl:with-param name="value">&#10013;</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </td>
            <td class="pr-3 w-50 left-column">
                <xsl:if test="$verseInNextMs">
                    <xsl:apply-templates select="$verseInNextMs" mode="renderVerseContent" />
                </xsl:if>
            </td>
            <td class="pr-2 index">
                <xsl:call-template name="renderVerseIndex"/>
            </td>
            <td class="pr-3 w-50 right-column">
                <xsl:apply-templates select="." mode="renderVerseContent" />
            </td>
        </tr>
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