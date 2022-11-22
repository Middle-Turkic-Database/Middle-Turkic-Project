<?php
defined('TYPO3_MODE') || die();

// Adds the content element to the "Type" dropdown
\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTcaSelectItem(
    'tt_content',
    'CType',
     [
         // title
         'LLL:EXT:middle_turkic_project/Resources/Private/Language/locallang.xlf:mscomparisonelement_title',
         // plugin signature: extkey_identifier
         'mscomparisonelement',
         // icon identifier
         'content-text-columns',
     ],
     'shortcut',
     'before'
 );

 // Adds the search element to the "Type" dropdown
\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTcaSelectItem(
    'tt_content',
    'CType',
     [
         // title
         'LLL:EXT:middle_turkic_project/Resources/Private/Language/locallang.xlf:searchelement_title',
         // plugin signature: extkey_identifier
         'searchelement',
         // icon identifier
         'mimetypes-x-content-form-search',
     ],
     'mscomparisonelement',
     'after'
 );