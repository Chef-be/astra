<?php

class RichTextService
{
	public static function prepareForStorage($content)
	{
		$content = str_replace(array("\r\n", "\r", "\0"), array("\n", "\n", ''), (string) $content);
		$content = trim($content);

		if ($content === '') {
			return '';
		}

		if (strpos($content, '&lt;') !== false && strpos($content, '<') === false) {
			$content = html_entity_decode($content, ENT_QUOTES, 'UTF-8');
		}

		if (self::looksLikeHtml($content)) {
			return self::sanitizeHtml($content);
		}

		return $content;
	}

	public static function render($content)
	{
		$content = trim((string) $content);

		if ($content === '') {
			return '';
		}

		if (strpos($content, '&lt;') !== false && strpos($content, '<') === false) {
			$content = html_entity_decode($content, ENT_QUOTES, 'UTF-8');
		}

		if (self::looksLikeHtml($content)) {
			return self::sanitizeHtml($content);
		}

		if (self::looksLikeBbCode($content)) {
			return BBCode::parse($content);
		}

		return makebr(htmlspecialchars($content, ENT_QUOTES, 'UTF-8'));
	}

	public static function looksLikeHtml($content)
	{
		return preg_match('/<(p|div|span|br|strong|b|em|i|u|s|ul|ol|li|blockquote|a|img|h[1-6]|table|thead|tbody|tr|th|td|figure|figcaption)\b/i', (string) $content) === 1;
	}

	protected static function looksLikeBbCode($content)
	{
		return preg_match('/\[(\/?)(b|i|u|img|url|quote|code|color|size|list|\*)/i', (string) $content) === 1;
	}

	protected static function sanitizeHtml($content)
	{
		$content = preg_replace('#<(script|style|iframe|object|embed|form|input|button|textarea|select)[^>]*>.*?</\\1>#is', '', $content);
		$content = strip_tags($content, '<p><div><span><br><strong><b><em><i><u><s><ul><ol><li><blockquote><a><img><h1><h2><h3><h4><h5><h6><table><thead><tbody><tr><th><td><figure><figcaption>');
		$content = preg_replace('/\son[a-z]+\s*=\s*(".*?"|\'.*?\'|[^\s>]+)/i', '', $content);
		$content = preg_replace('/\s(href|src)\s*=\s*([\"\'])\s*javascript:[^\\2]*\\2/i', '', $content);
		$content = preg_replace('/\sstyle\s*=\s*([\"\']).*?(expression|javascript:).*?\\1/i', '', $content);

		return $content;
	}
}
