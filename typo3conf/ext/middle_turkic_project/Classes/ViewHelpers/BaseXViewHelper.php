<?php

namespace UppsalaUniversity\MiddleTurkicProject\ViewHelpers;

use Closure;
use DOMDocument;
use TYPO3Fluid\Fluid\Core\Rendering\RenderingContextInterface;
use TYPO3Fluid\Fluid\Core\ViewHelper\AbstractViewHelper;
use TYPO3Fluid\Fluid\Core\ViewHelper\Traits\CompileWithRenderStatic;
use TYPO3\CMS\Core\Database\ConnectionPool;
use TYPO3\CMS\Core\Utility\GeneralUtility;
use TYPO3\CMS\Core\Log\LogManager;


class BaseXViewHelper extends AbstractViewHelper
{
    use CompileWithRenderStatic;

    private static function slugToTile($slug = "")
    {
        $queryBuilder = GeneralUtility::makeInstance(ConnectionPool::class)->getQueryBuilderForTable('pages');
        $queryBuilder = $queryBuilder->select('title')->from('pages')->where($queryBuilder->expr()->eq('slug', $queryBuilder->createNamedParameter($slug)));
        $result = $queryBuilder->execute()->fetch();

        return ($result['title']);
    }

    protected $escapeOutput = false;

    public function initializeArguments()
    {
        $this->registerArgument('ftQuery', 'string', 'The full text query', true);
        $this->registerArgument('pageNo', 'integer', 'Page number to return', false, 1);
        $this->registerArgument('numResults', 'integer', 'Number of results in each page', false, 10);
        $this->registerArgument('msSet', 'string', 'Manuscript Set to search', false, '');
        $this->registerArgument('msEditions', 'string', 'Manuscript Editions to search', false, '');
        $this->registerArgument('msBooks', 'string', 'Manuscript Books to search', false, '');
    }

    public static function renderStatic(array $arguments, Closure $renderChildrenClosure, RenderingContextInterface $renderingContext)
    {
        $BaseXURL = getenv('BaseXURL');
        $BaseXUser = getenv('BaseXUser');
        $BaseXPassword = getenv('BaseXPass');

        $logger = GeneralUtility::makeInstance(LogManager::class)->getLogger(__CLASS__);

        $url = sprintf("$BaseXURL/rest?run=search.xqm&q=%s&pageNo=%d&numResults=%d", $arguments['ftQuery'], $arguments['pageNo'], $arguments['numResults']);
        if ($arguments['msSet'] != '') {
            $url = $url . sprintf("&MSToSearch=%s", $arguments['msSet']);
        }
        if ($arguments['msEditions'] != '') {
            $url = $url . sprintf("&editionsToSearch=%s", $arguments['msEditions']);
        }
        if ($arguments['msBooks'] != '') {
            $url = $url . sprintf("&booksToSearch=%s", $arguments['msBooks']);
        }
        $url = str_replace(' ', '%20', $url);
        $ch_session = curl_init();
        curl_setopt_array($ch_session,
            array(
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_URL => $url,
                CURLOPT_HTTPAUTH => CURLAUTH_BASIC,
                CURLOPT_USERPWD => "$BaseXUser:$BaseXPassword"
            ));
        $response = curl_exec($ch_session);

        $xml = new DOMDocument();
        libxml_use_internal_errors(true);
        if ($xml->loadXML($response)) {
            foreach ($xml->getElementsByTagName('result') as $resultElement) {
                if ($path = $resultElement->attributes->getNamedItem('path')) {
                    $msName = $resultElement->attributes->getNamedItem("manuscriptName")->value;
                    $path = explode("/", $path->value);
                    $slug = "";
                    $it = 0;
                    while ($it < count($path)) {
                        if (str_starts_with($path[$it], $msName)) break;
                        $slug = $slug . "/" . $path[$it];
                        ++$it;
                    }
                    if ($slug != "") {
                        $msSetName = self::slugToTile("/manuscripts" . $slug);

                        $domAttribute = $xml->createAttribute('slug');
                        $domAttribute->value = $slug;
                        $resultElement->appendChild($domAttribute);
                    }
                    if (!empty($msSetName)) {
                        $domAttribute = $xml->createAttribute('msSetName');
                        $domAttribute->value = $msSetName;
                        $resultElement->appendChild($domAttribute);
                    }
                }
            }
            $response = $xml->saveXML();
        }

        return $response;
    }
}
