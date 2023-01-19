// google sheet to html to S3
<?php
require_once 'vendor/autoload.php';

putenv('GOOGLE_APPLICATION_CREDENTIALS=path/to/credentials.json');

$client = new Google_Client();
$client->useApplicationDefaultCredentials();
$client->setScopes(['https://www.googleapis.com/auth/spreadsheets']);

$service = new Google_Service_Sheets($client);

$spreadsheetId = 'YOUR_SPREADSHEET_ID';
$range = 'SHEET_NAME!A1:Z';
$response = $service->spreadsheets_values->get($spreadsheetId, $range);
$values = $response->getValues();

$html = '<table>';
foreach ($values as $row) {
    $html .= '<tr>';
    foreach ($row as $cell) {
        $html .= '<td>' . $cell . '</td>';
    }
    $html .= '</tr>';
}
$html .= '</table>';

// Create an S3 client
$s3 = new Aws\S3\S3Client([
    'region'  => 'YOUR_REGION',
    'version' => 'latest',
    'credentials' => [
        'key'    => 'YOUR_AWS_ACCESS_KEY',
        'secret' => 'YOUR_AWS_SECRET_KEY',
    ],
]);

// Upload the HTML file to the S3 bucket
$s3->putObject([
    'Bucket' => 'YOUR_BUCKET_NAME',
    'Key'    => 'path/to/file.html',
    'Body'   => $html,
    'ACL'    => 'public-read',
]);
