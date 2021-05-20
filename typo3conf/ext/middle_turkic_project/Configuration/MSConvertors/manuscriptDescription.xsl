<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:func="http://exslt.org/functions"
   xmlns:date="http://exslt.org/dates-and-times"
   xmlns:str="http://exslt.org/strings"
   xmlns:common="http://exslt.org/common"
   xmlns:mtdb="http://www.middleturkic.uu.se" exclude-result-prefixes="tei mtdb" extension-element-prefixes="func date str common">
   <xsl:import href="typo3conf/ext/middle_turkic_project/Configuration/MSConvertors/xml-to-string.xsl" />
   <xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes" />

   <!-- Variables -->

   <!-- External parameter -->
   <xsl:param name="manuscriptPath" select="'NO_PATH_AVAILABLE'" />
   <xsl:param name="xmlAddress" select="'default'" />
   <xsl:param name="pageURL" select="'NO_URL_AVAILABLE'" />

   <!-- Line Break -->
   <xsl:variable name="newLine">
      <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
   </xsl:variable>
   <!-- MDash-->
   <xsl:variable name="mDash">
      <xsl:text disable-output-escaping="yes">&#x2014;</xsl:text>
   </xsl:variable>
   <!-- End of Variables -->


   <!-- Checks the Existance of an element -->
   <func:function name="mtdb:exists">
      <xsl:param name="element" />
      <func:result select="($element and not($element/@ana)) or ($element/@ana != '#no')" />
   </func:function>

   <xsl:template match="/">
      <button type="button" class="d-block btn btn-link btn-lg btn-ExpCollAllAccard mb-1 mr-1 ml-auto d-print-none" data-toggle="tooltip" data-placement="top" title="Expand/Collapse All" data-trigger="hover">
         <i class="fas fa-plus-circle"></i>
      </button>

      <div class="accordion" id="accordion-100">
         <div class="accordion-item card">
            <div class="accordion-header card-header" id="accordion-heading-100-1">
               <h4 class="accordion-title">
                  <a href="#accordion-100-1" class="accordion-title-link collapsed" data-toggle="collapse" aria-expanded="false" aria-controls="accordion-100-1">
                     <span class="accordion-title-link-text">
                        <i class="fas fa-info-circle accardion-logo"/>
General Information</span>
                     <span class="accordion-title-link-state"></span>
                  </a>
               </h4>
            </div>
            <div id="accordion-100-1" class="accordion-collapse collapse show" aria-labelledby="accordion-heading-100-1">
               <div class="accordion-body card-body">
                  <div class="accordion-content accordion-content-left">
                     <div class="accordion-content-item accordion-content-text">
                        <dl class="row">

                           <dt class="col-sm-3">Language</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="language" select="/tei:TEI/tei:teiHeader/tei:profileDesc/tei:langUsage/tei:language" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($language)">
                                    <xsl:variable name="languageCode" select="$language/@ident" />
                                    <xsl:choose>
                                       <xsl:when test="$languageCode">
                                          <a href="https://iso639-3.sil.org/code/{$languageCode}" target="_blank" class="dotted-underline" data-toggle="tooltip" data-placement="top" title="{$languageCode}">
                                             <xsl:value-of select="$language" />
                                          </a>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:value-of select="$language" />
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Detailed Content</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="abstract" select="tei:TEI/tei:teiHeader/tei:profileDesc/tei:abstract" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($abstract)">
                                    <xsl:apply-templates select="$abstract" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Notes</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="note" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msContents/tei:msItem/tei:note" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($note)">
                                    <xsl:apply-templates select="$note" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Country, Settlement</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="settlement" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:settlement" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($settlement)">
                                    <xsl:value-of select="$settlement" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Repository</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="repository" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:repository" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($repository)">
                                    <xsl:value-of select="$repository" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Shelfmark</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="shelfmark" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:idno" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($shelfmark)">
                                    <xsl:value-of select="$shelfmark" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <xsl:variable name="keywords" select="/tei:TEI/tei:teiHeader/tei:profileDesc/tei:textClass/tei:keywords" />
                           <dt class="col-sm-3">
                              <xsl:choose>
                                 <xsl:when test="$keywords/@scheme and $keywords/@scheme != ''">
                                    <a href="{$keywords/@scheme}" target="_blank" class="dotted-underline" data-toggle="tooltip" data-placement="top" title="{$keywords/@scheme}">
                                                Keywords
                                    </a>
                                 </xsl:when>
                                 <xsl:otherwise>
                                                Keywords
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dt>
                           <dd class="col-sm-9">
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($keywords)">
                                    <xsl:apply-templates select="$keywords" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>
                        </dl>
                     </div>
                  </div>
               </div>
            </div>
         </div>

         <div class="accordion-item card">
            <div class="accordion-header card-header" id="accordion-heading-100-2">
               <h4 class="accordion-title">
                  <a href="#accordion-100-2" class="accordion-title-link collapsed" data-toggle="collapse" aria-expanded="false" aria-controls="accordion-100-2">
                     <span class="accordion-title-link-text">
                        <i class="fas fa-ruler-combined accardion-logo"/>
Physical Descrition</span>
                     <span class="accordion-title-link-state"></span>
                  </a>
               </h4>
            </div>
            <div id="accordion-100-2" class="accordion-collapse collapse" aria-labelledby="accordion-heading-100-2">
               <div class="accordion-body card-body">
                  <div class="accordion-content accordion-content-left">
                     <div class="accordion-content-item accordion-content-text">
                        <dl class="row">
                           <dt class="col-sm-3">Object Type</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="objectType" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:objectType" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($objectType)">
                                    <xsl:value-of select="$objectType" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Support</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="material" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:material" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($material)">
                                    <xsl:value-of select="$material" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Medium</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="medium" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:handDesc/tei:handNote[@medium='ink']" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($medium)">
                                    <xsl:apply-templates select="$medium" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <xsl:variable name="supportDimensions" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:extent/tei:dimensions[@type='leaf']" />
                           <dt class="col-sm-3">
                                          Support Dimensions
                              <xsl:if test="$supportDimensions/@unit">
                                             (
                                 <xsl:value-of select="$supportDimensions/@unit" />
                                             )
                              </xsl:if>
                           </dt>
                           <dd class="col-sm-9">
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($supportDimensions)">
                                    <xsl:value-of select="$supportDimensions/tei:height" />
                                                &#215;
                                    <xsl:value-of select="$supportDimensions/tei:width" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <xsl:variable name="textBlockDimensions" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:layoutDesc/tei:layout/tei:dimensions[@type='written']" />
                           <dt class="col-sm-3">
                                          Text-block Dimensions
                              <xsl:if test="$textBlockDimensions/@unit">
                                             (
                                 <xsl:value-of select="$textBlockDimensions/@unit" />
                                             )
                              </xsl:if>
                           </dt>
                           <dd class="col-sm-9">
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($textBlockDimensions)">
                                    <xsl:value-of select="$textBlockDimensions/tei:height" />
                                                &#215;
                                    <xsl:value-of select="$textBlockDimensions/tei:width" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Foliation</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="foliation" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:foliation" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($foliation)">
                                    <xsl:value-of select="$foliation" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Folios</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="folios" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:extent" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($folios)">
                                    <xsl:apply-templates select="$folios/text()" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Layout</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="layout" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:layoutDesc/tei:layout" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($layout)">
                                    <xsl:apply-templates select="$layout/*[not(name()='dimensions')]" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Catchwords</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="catchWords" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:collation/tei:catchwords" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($catchWords)">
                                    <xsl:value-of select="$catchWords" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Watermarks</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="waterMarks" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:watermark" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($waterMarks)">
                                    <xsl:value-of select="$waterMarks" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Binding</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="binding" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:bindingDesc/tei:binding" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($binding)">
                                    <xsl:apply-templates select="$binding" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">State of Preservation</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="condition" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:condition" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($condition)">
                                    <xsl:apply-templates select="$condition" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>
                        </dl>
                     </div>
                  </div>
               </div>
            </div>
         </div>

         <div class="accordion-item card">
            <div class="accordion-header card-header" id="accordion-heading-100-3">
               <h4 class="accordion-title">
                  <a href="#accordion-100-3" class="accordion-title-link collapsed" data-toggle="collapse" aria-expanded="false" aria-controls="accordion-100-3">
                     <span class="accordion-title-link-text">
                        <i class="fas fa-feather accardion-logo"/>
Description of hands</span>
                     <span class="accordion-title-link-state"></span>
                  </a>
               </h4>
            </div>
            <div id="accordion-100-3" class="accordion-collapse collapse" aria-labelledby="accordion-heading-100-3">
               <div class="accordion-body card-body">
                  <div class="accordion-content accordion-content-left">
                     <div class="accordion-content-item accordion-content-text">
                        <dl class="row">
                           <dt class="col-sm-3">Date of Copying</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="origDate" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origDate" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($origDate)">
                                    <xsl:apply-templates select="$origDate" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Copyist</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="copyist" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:handDesc/tei:handNote[@scribe='copyist']" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($copyist)">
                                    <xsl:apply-templates select="$copyist" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Translator</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="translator" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor[@role='translator']" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($translator)">
                                    <xsl:apply-templates select="$translator" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Place of Copying</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="origPlace" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origPlace" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($origPlace)">
                                    <xsl:apply-templates select="$origPlace" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Script</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="script" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:scriptDesc/tei:scriptNote" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($script)">
                                    <xsl:value-of select="$script" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Script Type</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="scriptType" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:handDesc/tei:handNote[@scope='sole']" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($scriptType)">
                                    <xsl:value-of select="$scriptType/@script" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Language</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="textLanguage" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msContents/tei:msItem/tei:textLang" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($textLanguage)">
                                    <xsl:apply-templates select="$textLanguage" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>
                        </dl>
                     </div>
                  </div>
               </div>
            </div>
         </div>

         <div class="accordion-item card">
            <div class="accordion-header card-header" id="accordion-heading-100-4">
               <h4 class="accordion-title">
                  <a href="#accordion-100-4" class="accordion-title-link collapsed" data-toggle="collapse" aria-expanded="false" aria-controls="accordion-100-4">
                     <span class="accordion-title-link-text">
                        <i class="fas fa-history accardion-logo" />
History</span>
                     <span class="accordion-title-link-state"></span>
                  </a>
               </h4>
            </div>
            <div id="accordion-100-4" class="accordion-collapse collapse" aria-labelledby="accordion-heading-100-4">
               <div class="accordion-body card-body">
                  <div class="accordion-content accordion-content-left">
                     <div class="accordion-content-item accordion-content-text">
                        <dl class="row">
                           <dt class="col-sm-3">Creation</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="creation" select="/tei:TEI/tei:teiHeader/tei:profileDesc/tei:creation" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($creation)">
                                    <xsl:apply-templates select="$creation" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Ownership</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="ownership" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:provenance/tei:name[@role='owner']" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($ownership)">
                                    <xsl:apply-templates select="$ownership" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>
                        </dl>
                     </div>
                  </div>
               </div>
            </div>
         </div>

         <div class="accordion-item card">
            <div class="accordion-header card-header" id="accordion-heading-100-5">
               <h4 class="accordion-title">
                  <a href="#accordion-100-5" class="accordion-title-link collapsed" data-toggle="collapse" aria-expanded="false" aria-controls="accordion-100-5">
                     <span class="accordion-title-link-text">
                        <i class="fas fa-bookmark accardion-logo"/>
References</span>
                     <span class="accordion-title-link-state"></span>
                  </a>
               </h4>
            </div>
            <div id="accordion-100-5" class="accordion-collapse collapse" aria-labelledby="accordion-heading-100-5">
               <div class="accordion-body card-body">
                  <div class="accordion-content accordion-content-left">
                     <div class="accordion-content-item accordion-content-text">
                        <xsl:variable name="bibList" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:additional/tei:listBibl" />
                        <xsl:choose>
                           <xsl:when test="mtdb:exists($bibList)">
                              <ul>
                                 <xsl:apply-templates select="$bibList/tei:bibl" />
                              </ul>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="$mDash" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </div>
                  </div>
               </div>
            </div>
         </div>

         <div class="accordion-item card">
            <div class="accordion-header card-header" id="accordion-heading-100-6">
               <h4 class="accordion-title">
                  <a href="#accordion-100-6" class="accordion-title-link collapsed" data-toggle="collapse" aria-expanded="false" aria-controls="accordion-100-6">
                     <span class="accordion-title-link-text">
                        <i class="fas fa-user-edit accardion-logo" />
Authorship</span>
                     <span class="accordion-title-link-state"></span>
                  </a>
               </h4>
            </div>
            <div id="accordion-100-6" class="accordion-collapse collapse" aria-labelledby="accordion-heading-100-6">
               <div class="accordion-body card-body">
                  <div class="accordion-content accordion-content-left">
                     <div class="accordion-content-item accordion-content-text">
                        <xsl:variable name="respStmt" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt" />
                        <xsl:choose>
                           <xsl:when test="$respStmt">
                              <p>
                                 <xsl:apply-templates select="$respStmt" />
                              </p>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="$mDash" />
                           </xsl:otherwise>
                        </xsl:choose>

                        <dl class="row">
                           <dt class="col-sm-3">Citation</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="editionStmt" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:editionStmt" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($editionStmt)">
                                    <xsl:apply-templates select="$editionStmt" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>

                           <dt class="col-sm-3">Licensing</dt>
                           <dd class="col-sm-9">
                              <xsl:variable name="licence" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence" />
                              <xsl:choose>
                                 <xsl:when test="mtdb:exists($licence)">
                                    <xsl:apply-templates select="$licence" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:copy-of select="$mDash" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </dd>
                        </dl>
                     </div>
                  </div>
               </div>
            </div>
         </div>

         <div class="accordion-item card">
            <div class="accordion-header card-header" id="accordion-heading-100-7">
               <h4 class="accordion-title">
                  <a href="#accordion-100-7" class="accordion-title-link collapsed" data-toggle="collapse" aria-expanded="false" aria-controls="accordion-100-7">
                     <span class="accordion-title-link-text">
                        <i class="fas fa-file-code accardion-logo" />
XML Source</span>
                     <span class="accordion-title-link-state"></span>
                  </a>
               </h4>
            </div>
            <div id="accordion-100-7" class="accordion-collapse collapse" aria-labelledby="accordion-heading-100-7">
               <div class="accordion-body card-body">
                  <div class="accordion-content accordion-content-left">
                     <div class="accordion-content-item accordion-content-text">
                        <p>
                           <a href="{$xmlAddress}" class="dotted-underline font-weight-bold" target="_blank">
                              <i class="far fa-eye mr-1" />
View the XML (TEI Epidoc)</a>
                        </p>
                        <p>
                           <a href="{$xmlAddress}" class="dotted-underline font-weight-bold" download="">
                              <i class="fas fa-file-download mr-1" />
Download the XML (TEI Epidoc)</a>
                        </p>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </xsl:template>

   <xsl:template match="tei:p">
      <p>
         <xsl:apply-templates />
      </p>
   </xsl:template>

   <xsl:template match="tei:l">
      <xsl:apply-templates />
      <xsl:if test="position() != last()">
         <xsl:copy-of select="$newLine" />
      </xsl:if>
   </xsl:template>

   <xsl:template match="tei:emph">
      <em>
         <xsl:apply-templates />
      </em>
   </xsl:template>

   <xsl:template match="tei:term">
      <xsl:apply-templates />
      <xsl:if test="position() != last()">
         <xsl:copy-of select="$newLine" />
      </xsl:if>
   </xsl:template>

   <xsl:template match="tei:origDate">
      <xsl:apply-templates />
      <xsl:if test="position() != last()">
         <xsl:copy-of select="$newLine" />
      </xsl:if>
   </xsl:template>

   <xsl:template match="tei:origPlace">
      <xsl:apply-templates />
      <xsl:if test="position() != last()">
         <xsl:copy-of select="$newLine" />
      </xsl:if>
   </xsl:template>

   <xsl:template match="tei:handNote[@scribe='copyist']">
      <xsl:apply-templates />
      <xsl:if test="position() != last()">
         <xsl:copy-of select="$newLine" />
      </xsl:if>
   </xsl:template>

   <xsl:template match="tei:editor[@role='translator']">
      <xsl:apply-templates />
      <xsl:if test="position() != last()">
         <xsl:copy-of select="$newLine" />
      </xsl:if>
   </xsl:template>

   <xsl:template match="tei:textLang">
      <xsl:apply-templates />
      <xsl:if test="mtdb:exists(../tei:locus)">
         ,
         <xsl:apply-templates select="../tei:locus" />
      </xsl:if>
      <xsl:if test="position() != last()">
         <xsl:copy-of select="$newLine" />
      </xsl:if>
   </xsl:template>

   <xsl:template match="tei:name[@role='owner']">
      <xsl:apply-templates />
      <xsl:if test="position() != last()">
         <xsl:copy-of select="$newLine" />
      </xsl:if>
   </xsl:template>

   <xsl:template match="tei:bibl">
      <li>
         <xsl:apply-templates />
      </li>
   </xsl:template>

   <xsl:template match="tei:respStmt">
      <xsl:apply-templates />
      <xsl:if test="position() != last()">
         <xsl:copy-of select="$newLine" />
      </xsl:if>
   </xsl:template>

   <xsl:template match="tei:resp">
      <span class="font-weight-bold">
         <xsl:apply-templates />
      </span>
   </xsl:template>

   <xsl:template match="tei:editionStmt">
      <xsl:apply-templates />
      <xsl:if test="position() != last()">
         <xsl:copy-of select="$newLine" />
      </xsl:if>
   </xsl:template>

   <xsl:template match="tei:licence">
      <a href="{./@target}" target="_blank" class="dotted-underline">
         <xsl:apply-templates />
      </a>
   </xsl:template>

   <xsl:template match="tei:persName">
      <xsl:variable name="personsFileName" select="substring-before(@ref, '#')" />
      <xsl:variable name="personsFilePath" select="concat($manuscriptPath, '/authority/', $personsFileName)" />
      <xsl:variable name="personId" select="substring-after(@ref, '#')" />
      <xsl:variable name="personInfo">
         <xsl:variable name="forename" select="document(str:encode-uri($personsFilePath, true()))/tei:TEI/tei:listPerson/tei:person[@xml:id=$personId]/tei:persName/tei:forename" />
         <xsl:variable name="surname" select="document(str:encode-uri($personsFilePath, true()))/tei:TEI/tei:listPerson/tei:person[@xml:id=$personId]/tei:persName/tei:surname" />
         <xsl:variable name="birth" select="document(str:encode-uri($personsFilePath, true()))/tei:TEI/tei:listPerson/tei:person[@xml:id=$personId]/tei:birth" />
         <xsl:variable name="death" select="document(str:encode-uri($personsFilePath, true()))/tei:TEI/tei:listPerson/tei:person[@xml:id=$personId]/tei:death" />
         <xsl:variable name="description" select="document(str:encode-uri($personsFilePath, true()))/tei:TEI/tei:listPerson/tei:person[@xml:id=$personId]/tei:p" />

         <div>
            <xsl:value-of select="$forename" />
            <xsl:value-of select="$surname" />
         </div>
         <xsl:if test="mtdb:exists($birth) or mtdb:exists($death)">
            <div class="mb-2">
               <xsl:text>(</xsl:text>
               <xsl:value-of select="$birth" />
               <xsl:text>--</xsl:text>
               <xsl:value-of select="$death" />
               <xsl:text>)</xsl:text>
            </div>
         </xsl:if>
         <xsl:if test="mtdb:exists($description)">
            <p class="text-left text-light">   
               <xsl:value-of select="$description" />
            </p>
         </xsl:if>
      </xsl:variable>
      <xsl:element name="span">
         <xsl:attribute name="class">
            <xsl:text>dotted-underline</xsl:text>
         </xsl:attribute>
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
            <xsl:call-template name="xml-to-string">
               <xsl:with-param name="node-set" select="common:node-set($personInfo)" />
            </xsl:call-template> 
         </xsl:attribute>
         <xsl:apply-templates />
      </xsl:element>
   </xsl:template>

   <xsl:template match="tei:date[@when-custom='Now-DayinMonth']">
      <xsl:value-of select="date:day-in-month()" />
   </xsl:template>

   <xsl:template match="tei:date[@when-custom='Now-MonthAbbr']">
      <xsl:value-of select="date:month-abbreviation()" />
   </xsl:template>

   <xsl:template match="tei:date[@when-custom='Now-Year']">
      <xsl:value-of select="date:year()" />
   </xsl:template>

   <xsl:template match="tei:ref[@target='currentPageURL']">
      <xsl:value-of select="$pageURL"/>
   </xsl:template>
</xsl:stylesheet>
