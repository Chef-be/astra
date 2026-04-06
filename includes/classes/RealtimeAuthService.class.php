<?php

class RealtimeAuthService
{
	protected static function getSharedSecret()
	{
		$salt = '';
		require ROOT_PATH.'includes/config.php';
		return $salt;
	}

	public static function createToken(array $userData)
	{
		$payload = array(
			'userId' => (int) $userData['id'],
			'username' => (string) $userData['username'],
			'authlevel' => (int) $userData['authlevel'],
			'universe' => (int) $userData['universe'],
			'allianceId' => isset($userData['ally_id']) ? (int) $userData['ally_id'] : 0,
			'expiresAt' => TIMESTAMP + 3600,
		);

		$encodedPayload = self::base64UrlEncode(json_encode($payload));
		$signature = self::base64UrlEncode(hash_hmac('sha256', $encodedPayload, self::getSharedSecret(), true));

		return $encodedPayload.'.'.$signature;
	}

	protected static function base64UrlEncode($value)
	{
		return rtrim(strtr(base64_encode($value), '+/', '-_'), '=');
	}
}
