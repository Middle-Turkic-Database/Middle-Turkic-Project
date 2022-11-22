<?php

require '../../../../typo3_src/vendor/autoload.php';
\TYPO3\CMS\Core\Core\SystemEnvironmentBuilder::run(0, \TYPO3\CMS\Core\Core\SystemEnvironmentBuilder::REQUESTTYPE_FE);

use \TYPO3\CMS\Core\Core\Environment;

logMessage('A new webhook received.');
$headers = getallheaders();
$content = file_get_contents('php://input');
file_put_contents(Environment::getProjectPath() . "/htdocs/typo3conf/ext/middle_turkic_project/logs/content.json", $content);


try {
  validateSecret($headers['X-Hub-Signature-256']);
  $decodedContent = json_decode($content);
  parseCommits($decodedContent);
} catch (Exception $e) {
  logMessage($e->getMessage());
  exit($e->getMessage());
}

logMessage('Commits applied successfully.');
exit();

function validateSecret($secret)
{
  if (!is_string($secret) || empty($secret)) {
    header("HTTP/1.1 500 Internal Server Error");
    throw new Exception('Secret is not valid!');
  }
  $sigCheck = 'sha256=' . hash_hmac('sha256', file_get_contents('php://input'), getenv('GitWebhookSecret'));
  $returnFlag = false;
  if (!hash_equals($secret, $sigCheck)) {
    header("HTTP/1.1 500 Internal Server Error");
    throw new Exception('Secret is not valid');
  } else {
    logMessage('Secret validated.');
  }
}

// $content: json decoded content
function parseCommits($content)
{
  $commitList = $content->commits;
  logMessage('Total number of commits: ' .  count($commitList));
  $masterBranch = getMasterBranch($content);
  $currentBranch = getCurrentBranch($content);
  if ($masterBranch !== $currentBranch) {
    throw new Exception('Commit is not on the master branch. Aborting.');
  }
  $contentsURL = getContentsURL($content);
  foreach ($commitList as $commit) {
    $commitID = getCommitID($commit);
    addFiles($commit->added, $contentsURL, $commitID, $masterBranch);
    modifyFiles($commit->modified, $contentsURL, $commitID, $masterBranch);
    removeFiles($commit->removed);
  }
}

function addFiles($addedList, $contentsURL, $commitID, $masterBranch)
{
  logMessage("Start of adding files.");
  foreach ($addedList as $filePath) {
    $fullAddress = getFullAddress($filePath, $contentsURL, $commitID, $masterBranch);
    $newFile = downloadFile($fullAddress);
    makeDirectory($filePath);
    if (file_put_contents($filePath, $newFile) === false) {
      logMessage("!!!Could not add file: " . $filePath . "!!!");
    } else {
      logMessage("File successfully added: " . $filePath);
    }
  }
}

function modifyFiles($modifiedList, $contentsURL, $commitID, $masterBranch)
{
  logMessage("Start of modifying files");
  foreach ($modifiedList as $filePath) {
    $fullAddress = getFullAddress($filePath, $contentsURL, $commitID, $masterBranch);
    $newFile = downloadFile($fullAddress);
    if (file_put_contents($filePath, $newFile) === false) {
      logMessage("!!!Could not modify file: " . $filePath . "!!!");
    } else {
      logMessage("File successfully modified: " . $filePath);
    }
  }
}

function removeFiles($removedList)
{
  logMessage("Start of removing files.");
  foreach ($removedList as $filePath) {
    if (unlink($filePath)) {
      logMessage("File successfully removed: " . $filePath);
    } else {
      logMessage("!!!Could not remove file: " . $filePath . "!!!");
    }
    $dirPath = substr($filePath, strrpos($filePath, "/"));
  }
}

function makeDirectory($filePath)
{
  $dirNames = explode("/", $filePath);
  $dirPath = "";
  for ($dirIt = 0; $dirIt < count($dirNames) - 1; $dirIt++) {
    $dirPath = $dirPath . ($dirIt > 0 ? "/" : "") . $dirNames[$dirIt];
    if (!is_dir($dirPath)) {
      if (mkdir($dirPath)) {
        logMessage("A new directory was created: " . $dirPath);
      } else {
        logMessage("Directory could not be created: " . $dirPath);
      }
    }
  }
}

function dirIsEmpty($dirPath)
{
  if ($dirPath == "") {
    return false;
  }

  if (!is_readable($dirPath)) {
    return false;
  }
  return (count(scandir($dirPath)) == 2);
}

function getFullAddress($filePath, $contentsURL, $commitID, $masterBranch)
{
  $fileInfo = getFileInfo($contentsURL . $filePath);
  $downloadURL = $fileInfo->download_url;
  // Replace branch name with commit id
  $searchSubStr = '/' . $masterBranch . '/';
  $replaceSubStr = '/' . $commitID . '/';
  $replacePosition = strrpos($downloadURL, $searchSubStr);
  $fullAddress = substr_replace($downloadURL, $replaceSubStr, $replacePosition, strlen($searchSubStr));
  return $fullAddress;
}

function getCommitID($commit)
{
  $commitID = $commit->id;
  if (!is_string($commitID) || empty($commitID)) {
    throw new Exception('Commit ID is not valid.');
  } else {
    logMessage("Commit ID extracted: " . $commitID);
  }

  return $commitID;
}

function getMasterBranch($content)
{
  $masterBranch = $content->repository->master_branch;

  if (!is_string($masterBranch) || empty($masterBranch)) {
    throw new Exception('Master Branch is not valid.');
  } else {
    logMessage("Master Branch extracted: " . $masterBranch);
  }

  return $masterBranch;
}

function getCurrentBranch($content)
{
  $currentBranch = explode("/", $content->ref);
  if (count($currentBranch) > 0) {
    $currentBranch = end($currentBranch);
  }

  if (!is_string($currentBranch) || empty($currentBranch)) {
    throw new Exception('Current Branch is not valid.');
  } else {
    logMessage("Current Branch extracted: " . $currentBranch);
  }

  return $currentBranch;
}

function getContentsURL($content)
{
  $contentsURL = $content->repository->contents_url;
  $contentsURL = explode('{+path}', $contentsURL, 2)[0];
  if (!is_string($contentsURL) || empty($contentsURL)) {
    throw new Exception('Contents URL is not valid.');
  } else {
    logMessage("ContentsURL extracted: " . $contentsURL);
  }

  return $contentsURL;
}

function getFileInfo($url)
{
  return json_decode(downloadFile($url));
}

function downloadFile($url, $filePath = null)
{
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_USERPWD, getenv('gitOAuth'));
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'User-Agent: ProcuctionServer'
  ]);
  if ($filePath != null) {
    curl_setopt($ch, CURLOPT_FILE, $filePath);
  }
  if (($downloadedFile = curl_exec($ch)) === false) {
    curl_close($ch);
    throw new Exception('Could not fetch file: ' . $url);
  }
  curl_close($ch);
  return $downloadedFile;
}

function logMessage($message)
{
  $errorMessage = date('Y.m.d H:i:s ::: ') . $message . "\n";
  if (isset($repositoryName)) {
    $repositoryName = $decodedContent->repository->name;
  }
  if (!isset($repositoryName)) {
    $repositoryName = "General";
  }
  $logsFolderPath = Environment::getProjectPath() . "/htdocs/typo3conf/ext/middle_turkic_project/logs";
  if (!is_dir($logsFolderPath)) {
    mkdir($logsFolderPath);
  }
  error_log($errorMessage, 3, $logsFolderPath . "/webhook" . "_" . $repositoryName . "_" . date('Ymd') . ".log");
}
