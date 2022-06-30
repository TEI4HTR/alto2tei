<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<?xml-stylesheet type="text/xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs xi xsi pc" xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.loc.gov/standards/alto/ns-v4# http://www.loc.gov/standards/alto/v4/alto-4-2.xsd"
    xmlns:pc="http://www.loc.gov/standards/alto/ns-v4#">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="/">

        <!-- Creation of a variable for storing file's name -->
        <xsl:variable name="file_name">
            <xsl:value-of select="replace(/pc:alto/pc:Description/pc:sourceImageInformation/pc:fileName, '.jpg', '')"/>
        </xsl:variable>

        <!-- Creation of a variable for storing output file name -->
        <xsl:variable name="output_name">
            <xsl:value-of select="concat($file_name, '.tei.xml')"/>
        </xsl:variable>

        <xsl:result-document href="{$output_name}" exclude-result-prefixes="xi xsi pc">
            <!-- teiHeader elements -->
            <TEI>
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>
                                <xsl:value-of select="$file_name"/>
                            </title>
                            <respStmt>
                                <resp>Transcribed with</resp>
                                <name> eScriptorium </name>
                            </respStmt>
                        </titleStmt>
                        <publicationStmt>
                            <p/>
                        </publicationStmt>
                        <sourceDesc>
                            <p/>
                        </sourceDesc>
                    </fileDesc>
                    <revisionDesc>
                        <xsl:element name="change"><xsl:attribute name="when"><xsl:value-of select="pc:PcGts/pc:Metadata/pc:Created"
                            /></xsl:attribute>Creation</xsl:element>
                        <xsl:element name="change"><xsl:attribute name="when"><xsl:value-of select="pc:PcGts/pc:Metadata/pc:LastChange"
                                /></xsl:attribute>Last change</xsl:element>
                    </revisionDesc>
                </teiHeader>
                <sourceDoc>
                    <!-- A <graphic> TEI element is used for tagging attributes of the <Page> node in the XML ALTO -->
                    <graphic>
                        <xsl:attribute name="xml:id">
                            <xsl:value-of select="$file_name"/>
                        </xsl:attribute>
                        <xsl:attribute name="url">
                            <xsl:value-of select="$file_name"/>
                        </xsl:attribute>
                        <xsl:attribute name="width">
                            <xsl:value-of select="concat(//pc:Page/@WIDTH, 'px')"/>
                        </xsl:attribute>
                        <xsl:attribute name="height">
                            <xsl:value-of select="concat(//pc:Page/@HEIGHT, 'px')"/>
                        </xsl:attribute>
                    </graphic>
                    <surfaceGrp>
                        <xsl:attribute name="facs">
                            <xsl:value-of select="concat('#', $file_name)"/>
                        </xsl:attribute>
                        <xsl:apply-templates select="//pc:Page"/>
                    </surfaceGrp>
                </sourceDoc>
            </TEI>
        </xsl:result-document>

    </xsl:template>
    <!-- A <TextBlock> node in the XML ALTO becomes a <surface> element in the TEI -->
    <!-- <surface> in the TEI represents all baselines associated with a <TextBlock> in the XML ALTO -->
    <xsl:template match="//pc:TextBlock">
        <xsl:element name="surface">
            <xsl:attribute name="xml:id">
                <xsl:value-of select="@ID"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="@TAGREFS">
                        <xsl:value-of select="@TAGREFS"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of>none</xsl:value-of>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="pc:Shape/pc:Polygon/@POINTS">
                    <xsl:attribute name="points">
                        <xsl:variable name="value" select="./pc:Shape/pc:Polygon/@POINTS"/>
                        <xsl:analyze-string select="$value" regex="([0-9]+)\s([0-9]+)">
                            <xsl:matching-substring>
                                <xsl:for-each select="$value">
                                    <xsl:value-of select="regex-group(1)"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="regex-group(2)"/>
                                    <xsl:text> </xsl:text>
                                </xsl:for-each>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <!-- For each <TextLine> in the XML ALTO, a <zone> element is created in the TEI. -->
            <xsl:for-each select="pc:TextLine">
                <!-- <zone> in the TEI represents baseline's mask in the XML ALTO -->
                <xsl:element name="zone">
                    <xsl:attribute name="xml:id">
                        <xsl:value-of select="@ID"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:value-of>mask</xsl:value-of>
                    </xsl:attribute>
                    <xsl:attribute name="points">
                        <xsl:variable name="value" select="./pc:Shape/pc:Polygon/@POINTS"/>
                        <xsl:analyze-string select="$value" regex="([0-9]+)\s([0-9]+)">
                            <xsl:matching-substring>
                                <xsl:for-each select="$value">
                                    <xsl:value-of select="regex-group(1)"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="regex-group(2)"/>
                                    <xsl:text> </xsl:text>
                                </xsl:for-each>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:attribute>
                    <!-- <path> in the TEI represents baseline's coordinates -->
                    <xsl:element name="path">
                        <xsl:attribute name="type">
                            <xsl:value-of>baseline</xsl:value-of>
                        </xsl:attribute>
                        <xsl:attribute name="points">
                            <xsl:variable name="value" select="./@BASELINE"/>
                            <xsl:analyze-string select="$value" regex="([0-9]+)\s([0-9]+)">
                                <xsl:matching-substring>
                                    <xsl:for-each select="$value">
                                        <xsl:value-of select="regex-group(1)"/>
                                        <xsl:text>,</xsl:text>
                                        <xsl:value-of select="regex-group(2)"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:for-each>
                                </xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:attribute>
                    </xsl:element>
                    <!-- <line> element in the TEI represents the transcription in the XML ALTO -->
                    <xsl:element name="line">
                        <xsl:value-of select="pc:String/@CONTENT"/>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
