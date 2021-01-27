<?php
defined('TYPO3_MODE') || die();

call_user_func(function () {

$GLOBALS['TCA']['tt_content']['ctrl']['typeicon_classes']['manuscriptheroimage_manuscript_hero_image'] = 'tx_manuscriptheroimage_manuscript_hero_image';
$tempColumns = [
    'tx_manuscriptheroimage_heroimage' => [
        'config' => [
            'type' => 'inline',
            'foreign_table' => 'sys_file_reference',
            'foreign_field' => 'uid_foreign',
            'foreign_sortby' => 'sorting_foreign',
            'foreign_table_field' => 'tablenames',
            'foreign_match_fields' => [
                'fieldname' => 'tx_manuscriptheroimage_heroimage',
            ],
            'foreign_label' => 'uid_local',
            'foreign_selector' => 'uid_local',
            'overrideChildTca' => [
                'columns' => [
                    'uid_local' => [
                        'config' => [
                            'appearance' => [
                                'elementBrowserType' => 'file',
                                'elementBrowserAllowed' => 'gif,jpg,jpeg,tif,tiff,bmp,pcx,tga,png,pdf,ai,svg',
                            ],
                        ],
                    ],
                ],
                'types' => [
                    [
                        'showitem' => '--palette--;LLL:EXT:core/Resources/Private/Language/locallang_tca.xlf:sys_file_reference.imageoverlayPalette;imageoverlayPalette, --palette--;;filePalette',
                    ],
                    [
                        'showitem' => '--palette--;LLL:EXT:core/Resources/Private/Language/locallang_tca.xlf:sys_file_reference.imageoverlayPalette;imageoverlayPalette, --palette--;;filePalette',
                    ],
                    [
                        'showitem' => '--palette--;LLL:EXT:core/Resources/Private/Language/locallang_tca.xlf:sys_file_reference.imageoverlayPalette;imageoverlayPalette, --palette--;;filePalette',
                    ],
                    [
                        'showitem' => '--palette--;LLL:EXT:core/Resources/Private/Language/locallang_tca.xlf:sys_file_reference.imageoverlayPalette;imageoverlayPalette, --palette--;;filePalette',
                    ],
                    [
                        'showitem' => '--palette--;LLL:EXT:core/Resources/Private/Language/locallang_tca.xlf:sys_file_reference.imageoverlayPalette;imageoverlayPalette, --palette--;;filePalette',
                    ],
                    [
                        'showitem' => '--palette--;LLL:EXT:core/Resources/Private/Language/locallang_tca.xlf:sys_file_reference.imageoverlayPalette;imageoverlayPalette, --palette--;;filePalette',
                    ],
                ],
            ],
            'filter' => [
                [
                    'userFunc' => 'TYPO3\\CMS\\Core\\Resource\\Filter\\FileExtensionFilter->filterInlineChildren',
                ],
            ],
            'appearance' => [
                'useSortable' => '1',
                'headerThumbnail' => [
                    'field' => 'uid_local',
                    'width' => '45',
                    'height' => '45c',
                ],
                'enabledControls' => [
                    'info' => 'tx_manuscriptheroimage_heroimage',
                    'new' => false,
                    'dragdrop' => 'tx_manuscriptheroimage_heroimage',
                    'sort' => false,
                    'hide' => 'tx_manuscriptheroimage_heroimage',
                    'delete' => 'tx_manuscriptheroimage_heroimage',
                ],
                'collapseAll' => '1',
                'expandSingle' => '1',
                'fileUploadAllowed' => '1',
            ],
            'maxitems' => '1',
            'minitems' => '0',
        ],
        'exclude' => '1',
        'label' => 'LLL:EXT:manuscript_hero_image/Resources/Private/Language/locallang_db.xlf:tt_content.tx_manuscriptheroimage_heroimage',
    ],
];
\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTCAcolumns('tt_content', $tempColumns);
$GLOBALS['TCA']['tt_content']['columns']['CType']['config']['items'][] = [
    'LLL:EXT:manuscript_hero_image/Resources/Private/Language/locallang_db.xlf:tt_content.CType.div._manuscriptheroimage_',
    '--div--',
];
$GLOBALS['TCA']['tt_content']['columns']['CType']['config']['items'][] = [
    'LLL:EXT:manuscript_hero_image/Resources/Private/Language/locallang_db.xlf:tt_content.CType.manuscriptheroimage_manuscript_hero_image',
    'manuscriptheroimage_manuscript_hero_image',
    'tx_manuscriptheroimage_manuscript_hero_image',
];
$tempTypes = [
    'manuscriptheroimage_manuscript_hero_image' => [
        'columnsOverrides' => [
            'bodytext' => [
                'config' => [
                    'richtextConfiguration' => 'default',
                    'enableRichtext' => 1,
                ],
            ],
        ],
        'showitem' => '--div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:general,--palette--;LLL:EXT:frontend/Resources/Private/Language/locallang_ttc.xlf:palette.general;general,tx_manuscriptheroimage_heroimage,--div--;LLL:EXT:frontend/Resources/Private/Language/locallang_ttc.xlf:tabs.appearance,--palette--;LLL:EXT:frontend/Resources/Private/Language/locallang_ttc.xlf:palette.frames;frames,--palette--;LLL:EXT:frontend/Resources/Private/Language/locallang_ttc.xlf:palette.appearanceLinks;appearanceLinks,--div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:language,--palette--;;language,--div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:access,--palette--;;hidden,--palette--;LLL:EXT:frontend/Resources/Private/Language/locallang_ttc.xlf:palette.access;access,--div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:categories,--div--;LLL:EXT:core/Resources/Private/Language/locallang_tca.xlf:sys_category.tabs.category,categories,--div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:notes,rowDescription,--div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:extended',
    ],
];
$GLOBALS['TCA']['tt_content']['types'] += $tempTypes;
\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addStaticFile(
    'manuscript_hero_image',
    'Configuration/TypoScript/',
    'manuscript_hero_image'
);

});

