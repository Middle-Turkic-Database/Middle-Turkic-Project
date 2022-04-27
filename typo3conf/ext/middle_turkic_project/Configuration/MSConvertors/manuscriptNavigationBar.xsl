<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:func="http://exslt.org/functions" xmlns:mtdb="http://www.middleturkic.uu.se" exclude-result-prefixes="tei mtdb" extension-element-prefixes="func">
  <xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes" />

  <!-- Variables -->
  
  <!-- End of Variables -->

  <!-- xmlAddress Parameter (external parameter) -->
  <xsl:param name="uniqueID" select="generate-id()" />

  <!-- Checks the Existance of an element -->
  <func:function name="mtdb:exists">
    <xsl:param name="element" />
    <func:result select="($element and not($element/@ana)) or ($element/@ana != '#no')" />
  </func:function>

  <xsl:template match="/">
    <xsl:variable name="msItemStruct" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msContents/tei:msItemStruct" />
    <xsl:if test="mtdb:exists($msItemStruct)">
      <nav class="nav ms-nav ms-nav-1st nav-fill nav-pills flex-column flex-sm-row mb-1">
        <xsl:apply-templates select="$msItemStruct/tei:title"  mode="msNav1stLevel"/>
      </nav>
      <div class="tab-content" id="{$uniqueID}-pills-tabContent">
        <xsl:apply-templates select="$msItemStruct/tei:title"  mode="msNav2ndLevel"/>
      </div>
      <form class="form-inline my-2 justify-content-center ms-selector-form">
        <label class="my-1 mr-2" for="{$uniqueID}-bookSelector">Book:</label>
        <select class="custom-select my-1 mr-sm-2" id="{$uniqueID}-bookSelector" name="bookSelector">
          <xsl:apply-templates select="$msItemStruct/tei:title"  mode="bookSelector" />
        </select>
        <div class="form-group mr-2" id="{$uniqueID}-chapterFormGroup">
          <label class="my-1 mr-sm-2" for="{$uniqueID}-chapterNum">
            Chapter:
          </label>        
          <xsl:element name="input">
            <xsl:attribute name="type">
              <xsl:text>number</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="class">
              <xsl:text>form-control my-1</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="$uniqueID" />
              <xsl:text>-chapterNum</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="name">
              <xsl:text>chapterNum</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="value">
              <xsl:text>1</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="placeholder">
              <xsl:text>1</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="min">
              <xsl:text>1</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="max" />
            <xsl:attribute name="size" />
            <xsl:attribute name="step">
              <xsl:text>1</xsl:text>
            </xsl:attribute>
          </xsl:element>
        </div>
        <button type="submit" class="btn btn-primary my-1">Show</button>
      </form>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:msItemStruct/tei:title" mode="msNav1stLevel">
    <xsl:element name="a">
      <xsl:attribute name="class">
        <xsl:text>nav-item flex-fill nav-link</xsl:text>
        <xsl:if test="position() &lt; 2">
          <xsl:text> active</xsl:text>
        </xsl:if>
        <xsl:if test="./@type = 'book'">
          <xsl:text> dropdown-toggle</xsl:text>
        </xsl:if>
      </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="$uniqueID"></xsl:value-of>
        <xsl:text>-pills-</xsl:text>
        <xsl:value-of select="@n" />
      </xsl:attribute>
      <xsl:attribute name="data-toggle">
        <xsl:text>pill</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="href">
        <xsl:text>#</xsl:text>
        <xsl:value-of select="$uniqueID" />
        <xsl:text>-pills-</xsl:text>
        <xsl:value-of select="@n" />
        <xsl:text>-tab</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="role">
        <xsl:text>tab</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="aria-controls">
        <xsl:text>#</xsl:text>
        <xsl:value-of select="$uniqueID" />
        <xsl:text>-pills-</xsl:text>
        <xsl:value-of select="@n" />
        <xsl:text>-tab</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="aria-selected">
        <xsl:text>true</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="data-bookNo">
        <xsl:value-of select="@n" />
      </xsl:attribute>
      <xsl:attribute name="title">
          <xsl:copy-of select="normalize-space(text()[normalize-space()][1])"/>
      </xsl:attribute>
      <xsl:attribute name="data-placement">
        <xsl:text>top</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="data-trigger">
        <xsl:text>hover</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="data-delay">
        <xsl:text>{"show":500, "hide":0}</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:text>flex: 1 1 0px</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="tei:abbr" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:msItemStruct/tei:title" mode="msNav2ndLevel">
    <xsl:element name="div">
      <xsl:attribute name="class">
        <xsl:text>tab-pane</xsl:text>
        <xsl:if test="position() &lt; 2">
          <xsl:text> show active</xsl:text>
        </xsl:if>
      </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="$uniqueID" />
        <xsl:text>-pills-</xsl:text>
        <xsl:value-of select="@n"></xsl:value-of>
        <xsl:text>-tab</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="role">
        <xsl:text>tabpanel</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="aria-labelleadby">
        <xsl:value-of select="$uniqueID" />
        <xsl:text>-pills-</xsl:text>
        <xsl:value-of select="@n" />
        <xsl:text>-tab</xsl:text>
      </xsl:attribute>
      <xsl:if test="mtdb:exists(tei:measure)">
        <xsl:element name="nav">
          <xsl:attribute name="class">
            <xsl:text>nav ms-nav ms-nav-2nd nav-fill nav-pills</xsl:text>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="position() &lt; 2">
              <xsl:call-template name="msNav2ndLevelLoop">
                <xsl:with-param name="max" select="number(tei:measure/@quantity)" />
                <xsl:with-param name="firstLevelIsActive" select="'true'" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="msNav2ndLevelLoop">
                <xsl:with-param name="max" select="number(tei:measure/@quantity)" />
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:msItemStruct/tei:title" mode="bookSelector">
    <xsl:element name="option">
      <xsl:attribute name="value">
        <xsl:value-of select="@n" />
      </xsl:attribute>
      <xsl:attribute name="data-chapternum">
        <xsl:choose>
          <xsl:when test="mtdb:exists(tei:measure)">
            <xsl:value-of select="tei:measure/@quantity"></xsl:value-of>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>0</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:copy-of select="text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template name="msNav2ndLevelLoop">
    <xsl:param name="iterator" select="number(1)" />
    <xsl:param name="max" />
    <xsl:param name="firstLevelIsActive" select="'false'" />

    <xsl:if test="$max &gt;= $iterator">
      <xsl:element name="a">
        <xsl:attribute name="class">
          <xsl:text>nav-item flex-fill nav-link</xsl:text>
          <xsl:if test="(($firstLevelIsActive = 'true') and (position() &lt; 2))">
            <xsl:text> active</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <xsl:attribute name="role">
          <xsl:text>tab</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="data-toggle">
          <xsl:text>pill</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="href">
          <xsl:text>#</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="$iterator" />
        </xsl:attribute>
        <xsl:attribute name="data-placement">
          <xsl:text>bottom</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="data-trigger">
          <xsl:text>hover</xsl:text>
        </xsl:attribute>  
        <xsl:attribute name="data-chapterNo">
          <xsl:value-of select="$iterator"></xsl:value-of>
        </xsl:attribute>
      </xsl:element>  
      
      <xsl:call-template name="msNav2ndLevelLoop">
        <xsl:with-param name="iterator" select="$iterator + 1" />
        <xsl:with-param name="max" select="$max" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>
