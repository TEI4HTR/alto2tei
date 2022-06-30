# Alto2tei 

This repository stores an XSLT for transforming a XML ALTO file into XML-TEI. The XSLT was modified from the [PAGE XML version](https://github.com/TEI4HTR/page2tei) created for the LECTAUREP (INRIA - Archives nationales), and xml files resulting from the transformation.

For each annotation region, `<TextBlock>` in a XML ALTO file, a `<surface>` element is created in the TEI file.

## Repository tree

```
├── xmlalto
├── tei
└── alto_to_tei.xsl
```

* The XSLT 
* A directory named `xmlalto`, in which are stored XML ALTO files.
* The directory named `tei` stores the TEI files resulting from the transformed XML ALTO.

## Cite this work

```
Chagué, A., Chiffoleau, F., & Scheithauer, H. (2022). alto2tei, an XSL Transformation to transform XML ALTO into TEI XML (Version 1.0.0) [Computer software]
```