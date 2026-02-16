<?php

/**
 * Extension Manager/Repository config file for ext "c4theme".
 */
$EM_CONF[$_EXTKEY] = [
    'title' => 'c4theme',
    'description' => 'Seite',
    'category' => 'templates',
    'constraints' => [
        'depends' => [
            'typo3' => '13.0.0-13.9.99',
            'bootstrap_package' => '15.0.0-15.9.99',
        ],
        'conflicts' => [
        ],
    ],
    'autoload' => [
        'psr-4' => [
            'Conrat\\C4theme\\' => 'Classes',
        ],
    ],
    'state' => 'stable',
    'uploadfolder' => 0,
    'createDirs' => '',
    'clearCacheOnLoad' => 1,
    'author' => 'Martin',
    'author_email' => 'mlehmann@conrat.de',
    'author_company' => 'ConRat',
    'version' => '1.0.2',
];
