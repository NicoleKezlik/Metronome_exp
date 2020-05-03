<?php
header('Content-Type: text/html; charset=utf-8');
$post_data = json_decode(file_get_contents_utf8('php://input'), true); 
// the directory "data" must be writable by the server
$name = "data/".$post_data['filename'].".csv"; 
$data = $post_data['filedata'];
// write the file to disk
file_put_contents($name, "\xEF\xBB\xBF". $data);

function file_get_contents_utf8($fn) {
     $content = file_get_contents($fn);
      return mb_convert_encoding($content, 'UTF-8',
          mb_detect_encoding($content, 'UTF-8, ISO-8859-8', true));
}
?>