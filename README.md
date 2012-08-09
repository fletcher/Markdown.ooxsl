Title:			Markdown export plugin for OmniOutliner  
Author:			Fletcher T. Penney  
Copyright:		(c) 2009-2011, Fletcher T. Penney.  


# Introduction #

This plugin for OmniOutliner allows you to export as a text file, suitable for
processing through Markdown or MultiMarkdown. For more information, please
see:

<http://fletcherpenney.net/multimarkdown/multimarkdown_and_omnioutliner/>

This script is "agnostic" as to the version of MultiMarkdown syntax being
used, so it is compatible with MMD 2, or MMD 3.


# Where to Get It #

* [Markdown.ooxsl](https://github.com/fletcher/Markdown.ooxsl)


**Note**: *There are actually two versions of the export function included. In
the text only version, images can be included, but must be handled manually.
In the version with attachments, you can include images in your OmniOutliner
document that will be exported. There is a single bundle with both versions.*


# How to use this #

* Install the plugin (see the OmniOutliner directions), but I recommend
  placing in:

		~/Library/Application Support/OmniOutliner 3/Plug-Ins

* Create an outline

* Export it as Markdown text


# Special Features #

The outline hierarchy is converted into headers of appropriate depths.

Notes are added as plain text after the header.


# Metadata #

In order to use the metadata feature of MultiMarkdown, the last top level item
in the outline should be called `Metadata`, and each sub-item is the name of
the key. The notes are the data for that key. In particular, the `Title`, and
`Format` keys are of use. Set `Format` to `complete` if you want to have
MultiMarkdown generate an entire HTML file, complete with header, etc.

Example:

    First Item
    Second Item
         Sub-Item
    Metadata
         Title (with note containing your document's name)
         Format (with note containing "complete")


# Private Notes #

You can use the outline to store notes that are **NOT** exported to the
Markdown document by naming that section of the outline `My Notes` (not case
sensitive).

One thing to remember is that Note sections **ARE** counted in the numbering
scheme within OO, but are **NOT** counted (obviously) in the exported version.
This could lead to numbering discrepancies between the original outline and
the final version. To avoid this (if it matters to you), I recommend ensuring
that the Private Note sections be included as the last (or only) children at
any given level.


# Images #

It is possible to include images in your OmniOutliner document that are
exported appropriately. If you export using the "Folder" version, you will end
up with a folder that includes a Markdown text file, `index.text`, as
well as copies of all the attachments in your OmniOutliner document. If your
image is included in an "active" part of the OO document, it will be
automatically included in the Markdown output. Note, however, that this
approach does not allow you to include an alt text attribute.

Instead, you could put the image in a `My Notes` section - the image will be
exported, but not included in the text. You can then hand create a Markdown
image reference, allowing a caption. For example, if you add an image named
`image-name.png`, you can reference it in your document:

    ![This is a caption that can be included about the image](image-name.png
    "Alternate Text for Image")


# Version History #

* 1.1r2 - I *grudgingly* hacked the plugin to make it work with the version of
  xsltproc that ships with Mac OS X, and does not properly support the
  `last()` function.... **Note:** it should work properly with OmniOutliner
  3.5b2 and beyond.

* 1.1 - combine both formats into a single plug-in

* 1.0 - initial public release

