<?php

/**
 * Extension Manager/Repository config file for ext "middle_turkic_project".
 */
$EM_CONF['middle_turkic_project'] = [
    'title' => 'Middle Turkic Project',
    'description' => '',
    'category' => 'templates',
    'constraints' => [
        'depends' => [
            'bootstrap_package' => '10.0.0-11.0.99',
            'vhs' => '6.0.0',
            'file_list' => '2.4.2',
            'cobj_xpath' => '1.9.0',
            'cobj_xslt' => '1.9.0',
            'manuscript_hero_image' => '0.1.0',
            'recaptcha' => '10.0.0',
        ],
        'conflicts' => [
        ],
    ],
    'autoload' => [
        'psr-4' => [
            'UppsalaUniversity\\MiddleTurkicProject\\' => 'Classes',
        ],
    ],
    'state' => 'stable',
    'uploadfolder' => 0,
    'createDirs' => '',
    'clearCacheOnLoad' => 1,
    'author' => 'Mohsen Emami',
    'author_email' => 'mohsen.emami@lingfil.uu.se',
    'author_company' => 'Uppsala University',
    'version' => '1.0.0',
];
