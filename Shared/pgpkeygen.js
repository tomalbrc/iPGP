/**
 * Debug msg handler.
 */

var _debug = function(msg) {
	var dbg = false;
	
    window.webkit.messageHandlers.skey.postMessage(msg);
    
	if( dbg ) {
		console.log(msg);
	}
}

/**
 * Generate a key pair and place base64 encoded values into specified DOM elements.
 */
var genKeyPair = function (nameVar, emailVar, commentVar, passVar, algoVar, keySize) {
	
	// Get params from user input
	var name = nameVar;
	var email = emailVar ? " <" + emailVar + ">" : "";;
	var comments = (commentVar != "" ) ? " (" + commentVar + ")" : "";
	var bitlength = keySize;
	var algorithm = algoVar; //ecc
	var expire = 0;
	var passphrase = passVar
	
	// Set ECC flag
	var use_ecc = false;
	if (algorithm == 'ecc') {
		use_ecc = true;
	}
	
	// Calculate subkey size
	var subkey_bitlength = calcSubkeySize(algorithm, bitlength);
	
	
	// Create a progress hook
	var my_asp = new kbpgp.ASP({
		progress_hook: function(o) {
           //window.webkit.messageHandlers.data.postMessage(o);
		   // disabled for now
		}
	});
	
	var F = kbpgp["const"].openpgp;

	var opts = {
		asp: my_asp, // set progress hook
		userid: name + email +comments,
		ecc: use_ecc,
		primary: {
			nbits: bitlength,
			flags: F.certify_keys | F.sign_data | F.auth | F.encrypt_comm | F.encrypt_storage,
			expire_in: 0 // never expires
		},
		subkeys: [
		{
			nbits: subkey_bitlength,
			flags: F.sign_data,
			expire_in: 86400 * 365 * 8
		}, {
			nbits: subkey_bitlength,
			flags: F.encrypt_comm | F.encrypt_storage,
			expire_in: 86400 * 365 * 8
		}
		]
	};	
	
	_debug("Calling KeyManager.generate()");
	kbpgp.KeyManager.generate(opts, function(err, alice) {
	 	if (!err) {
		 	_debug("Callback invoked()");
		 	var _passphrase = passphrase			
	    	// sign alice's subkeys
			alice.sign({}, function(err) {
				_debug(alice);
				_debug("KeyID: " + alice.get_pgp_short_key_id());
				// export; dump the private with a passphrase
				alice.export_pgp_private_to_client ({
		        	passphrase: _passphrase
		      	}, function(err, pgp_private) {
                    window.webkit.messageHandlers.skey.postMessage(pgp_private);
                });
			  	alice.export_pgp_public({}, function(err, pgp_public) {
                    window.webkit.messageHandlers.pkey.postMessage(pgp_public);
                });
		    });
	  	}
	});
}

/**
 * Download public key as a base64 encoded value.
 */
var calcSubkeySize = function (algo, bitlength) {
	if( algo == 'rsa' ) {
		// Return the same exact bitlength for RSA subkeys
		return bitlength;
	}
	else if ( algo == 'ecc' ) {
		// For ECC the subkeys should be smaller
		switch(bitlength) {
			case 256:
				return 163;
			case 384:
				return 256;
			case 512:
				return 384;
			default:
				_debug("ERROR: Unexpected bitlength found for ECC algorithm!");
				return 0;
		}
	}
	else {
		_debug("ERROR: Unexpected algorithm found!");
		return 0;
	}
}

