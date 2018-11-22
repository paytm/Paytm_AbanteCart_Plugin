<?php
/*------------------------------------------------------------------------------
  $Id$
  AbanteCart, Ideal OpenSource Ecommerce Solution
  http://www.AbanteCart.com
  Copyright © 2011-2015 Belavier Commerce LLC
  This source file is subject to Open Software License (OSL 3.0)
  Lincence details is bundled with this package in the file LICENSE.txt.
  It is also available at this URL:
  <http://www.opensource.org/licenses/OSL-3.0>
------------------------------------------------------------------------------*/

if ( !defined ( 'DIR_CORE' )) {
	header ( 'Location: static_pages/' );
}
class ControllerResponsesExtensionPaytmpayments extends AController {

	public function main() {
		include_once 'encdec_paytm.php';
    	$template_data['button_confirm'] = $this->language->get('button_confirm');
		$template_data['button_back'] = $this->language->get('button_back');
		$this->load->model('checkout/order');
		$this->load->model('extension/paytm_payments');
		$this->loadModel('account/customer');
		$CUST_ID=$this->customer->getId();
		$order_info = $this->model_checkout_order->getOrder($this->session->data['order_id']);
		$template_data['PAYTM_MERCHANT_KEY'] = $this->config->get('paytm_payments_merchant_key');
		$template_data['PAYTM_MERCHANT_MID'] = $this->config->get('paytm_payments_merchant_mid');
		$template_data['PAYTM_MERCHANT_WEBSITE'] = $this->config->get('paytm_payments_merchant_website');
		// $template_data['PAYTM_MERCHANT_CUSTOM_CALLBACKURL'] = $this->config->get('paytm_payments_custom_callbackurl');
		$template_data['PAYTM_MERCHANT_CALLBACK_URL'] = trim($this->config->get('paytm_payments_callback_url'));
		// $template_data['PAYTM_ENVIRONMENT'] = $this->config->get('paytm_payments_test');
		$template_data['PAYTM_TRANSACTION_URL'] = $this->config->get('paytm_payments_merchant_transaction_url');
		$template_data['PAYTM_TRANSACTION_STATUS_URL'] = $this->config->get('paytm_payments_merchant_transaction_status_url');
		$template_data['PAYTM_CALLBACK'] = $this->config->get('paytm_payments_callback');
		$template_data['MID'] = $template_data['PAYTM_MERCHANT_MID'];
        $template_data['ORDER_ID'] = $this->session->data['order_id'].time();
		if($CUST_ID =='' || $CUST_ID==0){
			$template_data['CUST_ID'] = $order_info['email'];
		}
		else{
			$template_data['CUST_ID'] = $CUST_ID;
		}
        $template_data['INDUSTRY_TYPE_ID'] = $this->config->get('paytm_payments_merchant_industry'); 
        $template_data['CHANNEL_ID'] = 'WEB';
        $template_data['TXN_AMOUNT'] = $this->currency->format($order_info['total'], $order_info['currency'], $order_info['value'], FALSE);
        $template_data['WEBSITE'] = $template_data['PAYTM_MERCHANT_WEBSITE'];        
		$PAYTM_DOMAIN = "pguat.paytm.com";
		if ($template_data['PAYTM_ENVIRONMENT'] == 'live') {
			$PAYTM_DOMAIN = 'secure.paytm.in';
		}
		$template_data['PAYTM_STATUS_QUERY_URL']=$template_data['PAYTM_TRANSACTION_STATUS_URL'];
		$template_data['PAYTM_TXN_URL']=$template_data['PAYTM_TRANSACTION_URL'];
        $paramList["MID"] = $template_data['MID'];
		$paramList["ORDER_ID"] = $template_data['ORDER_ID'];
		$paramList["CUST_ID"] = $template_data['CUST_ID'];
		$paramList["INDUSTRY_TYPE_ID"] = $template_data['INDUSTRY_TYPE_ID'];
		$paramList["CHANNEL_ID"] = $template_data['CHANNEL_ID'];
		$paramList["TXN_AMOUNT"] = $template_data['TXN_AMOUNT'];
		$paramList["WEBSITE"] = $template_data['WEBSITE'];
		
		$template_data['CALLBACK_URL'] =$template_data['PAYTM_MERCHANT_CALLBACK_URL']!=''?$template_data['PAYTM_MERCHANT_CALLBACK_URL']:$this->html->getSecureURL('extension/paytm_payments/callback');
		$paramList["CALLBACK_URL"] = $template_data['CALLBACK_URL'];

		$template_data['customCallbackUrl']=$template_data['PAYTM_MERCHANT_CUSTOM_CALLBACKURL'];
		$template_data['callBackUrl']=$template_data['PAYTM_MERCHANT_CALLBACK_URL'];
		$checkSum = getChecksumFromArray($paramList, $this->config->get('paytm_payments_merchant_key'));
		$template_data['CHECKSUMHASH']=$checkSum;
		$this->load->library('encryption');
		$encryption = new AEncryption($this->config->get('encryption_key'));
		$template_data['order_id'] = $encryption->encrypt($this->session->data['order_id']);
		if ($this->request->get['rt'] != 'checkout/guest_step_3') {
			$template_data['back'] = $this->html->getSecureURL('checkout/payment');
		} else {
			$template_data['back'] = $this->html->getSecureURL('checkout/guest_step_2');
		}
		$this->view->batchAssign( $template_data );
		$this->processTemplate('responses/paytm_payments.tpl' );
	}
	public function callback() {
		include_once 'encdec_paytm.php';
		$this->load->model('extension/paytm_payments');
		$this->load->model('checkout/order');
		$this->loadLanguage('paytm_payments/paytm_payments');
		$template_data['title'] = sprintf($this->language->get('heading_title'), $this->config->get('store_name'));
		if (!isset($this->request->server['HTTPS']) || ($this->request->server['HTTPS'] != 'on')) {
			$template_data['base'] = HTTP_SERVER;

		} else {
			$template_data['base'] = HTTPS_SERVER;
		}
		$template_data['charset'] = 'utf-8';
		$template_data['language'] = $this->language->get('code');
		$template_data['direction'] = $this->language->get('direction');
		$template_data['heading_title'] = sprintf($this->language->get('heading_title'), $this->config->get('store_name'));
		$template_data['text_response'] = $this->language->get('text_response');
		$template_data['text_success'] = $this->language->get('text_success');
        $template_data['text_success_wait'] = sprintf($this->language->get('text_success_wait'), $this->html->getSecureURL('checkout/success'));
		$template_data['text_failure'] = $this->language->get('text_failure');
		$template_data['text_failure_wait'] = sprintf($this->language->get('text_failure_wait'), $this->html->getSecureURL('checkout/cart'));
		$paytmChecksum = "";
		$paramList = array();
		$isValidChecksum = "FALSE";
		$paramList = $_POST;
		$paytmChecksum = isset($_POST["CHECKSUMHASH"]) ? $_POST["CHECKSUMHASH"] : "";
		$PAYTM_MERCHANT_KEY = $this->config->get('paytm_payments_merchant_key');
		$isValidChecksum = verifychecksum_e($paramList, $PAYTM_MERCHANT_KEY, $paytmChecksum);
		if($isValidChecksum == "TRUE") 
		{		
			if (isset($_REQUEST['STATUS']) && ($_REQUEST['STATUS'] == 'TXN_SUCCESS')) 
			{
				// Create an array having all required parameters for status query.
				$requestParamList = array("MID" => $this->config->get('paytm_payments_merchant_mid') , "ORDERID" => $_REQUEST['ORDERID']);
				
				$StatusCheckSum = getChecksumFromArray($requestParamList, $this->config->get('paytm_payments_merchant_key'));
				
				$requestParamList['CHECKSUMHASH'] = $StatusCheckSum;
				
				$check_status_url = $this->config->get('paytm_payments_merchant_transaction_status_url');
				
				$responseParamList = callNewAPI($check_status_url, $requestParamList);
				
				if($responseParamList['STATUS']=='TXN_SUCCESS' && $responseParamList['TXNAMOUNT']==$_REQUEST['TXNAMOUNT'])
				{	
					$this->load->model('checkout/order');
					$this->model_checkout_order->confirm($this->session->data['order_id'], $this->config->get('paytm_payments_order_status_id'));
					$this->redirect($this->html->getSecureURL('checkout/success'));
				}
				else{
					$template_data['continue'] = $this->html->getSecureURL('checkout/cart');
					$this->view->batchAssign( $template_data );
					$this->processTemplate('responses/paytm_payments_failure.tpl' );
				}
			} 
			else 
			{			
	            $template_data['continue'] = $this->html->getSecureURL('checkout/cart');
	            $this->view->batchAssign( $template_data );
				$this->processTemplate('responses/paytm_payments_failure.tpl' );
			}
		}
		else 
		{			
            $template_data['continue'] = $this->html->getSecureURL('checkout/cart');
            $this->view->batchAssign( $template_data );
			$this->processTemplate('responses/paytm_payments_failure.tpl' );
		}
		$this->processTemplate();
	}

	public function applyCode(){
		$this->load->model('extension/paytm_payments');
		include_once 'encdec_paytm.php';
		$codeApply='wrong';
		$json=array();
		// echo "<pre>";print_r($_POST);	// PROMO_CAMP_ID
		unset($_POST['CHECKSUMHASH']);
		if(isset($_POST['PROMO_CAMP_ID'])){
			unset($_POST['PROMO_CAMP_ID']);
		}
		if(isset($_POST['promoCode'])){
			$promoCode=$_POST['promoCode'];
			unset($_POST['promoCode']);
			if(trim($promoCode)!=''){
				$promocode_value = $this->config->get('promocode_value');
				$promocode_local_validation = $this->config->get('promocode_local_validation');
				if($promocode_local_validation=='enabled'){
					$promocodeValueArr=explode(',',$promocode_value);
					if(trim($promocodeValueArr[0])!=''){
						foreach ($promocodeValueArr as $key => $value) {
							if(trim($value)==trim($promoCode)){
								$_POST['PROMO_CAMP_ID']=trim($value);
								$codeApply='success';
							}
						}
					}
				}else{
					$codeApply='success';
					$_POST['PROMO_CAMP_ID']=trim($promoCode);
				}
			}else{
				$codeApply='remove';
			}
		}
		$checkSum = getChecksumFromArray($_POST, $this->config->get('paytm_payments_merchant_key'));
		$_POST['CHECKSUMHASH']=$checkSum;
		// echo "<pre>";print_r($_POST);
		$str='';
		foreach ($_POST as $key => $value) {
			$str.='<input name="'.$key.'"    type="hidden"  value="'.$value.'"   >';
		}
		$json['message']=$codeApply;
		$json['hiddenFields']=$str;
		echo json_encode($json);die;
	}

	public function curltest(){
		$debug = array();
		if(!function_exists("curl_init")){
			$debug[0]["info"][] = "cURL extension is either not available or disabled. Check phpinfo for more info.";

		}else{ 
			// this site homepage URL
			$check_status_url = $this->config->get('paytm_payments_merchant_transaction_status_url');
			$testing_urls = array(
				$this->html->getSecureURL(),
				"www.google.co.in",
				$check_status_url
			);
			// loop over all URLs, maintain debug log for each response received
			foreach($testing_urls as $key=>$url){
				// echo $url."<br>";
				$debug[$key]["info"][] = "Connecting to <b>" . $url . "</b> using cURL";

				$ch = curl_init($url);
				curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
				$res = curl_exec($ch);

				if (!curl_errno($ch)) {
					$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
					$debug[$key]["info"][] = "cURL executed succcessfully.";
					$debug[$key]["info"][] = "HTTP Response Code: <b>". $http_code . "</b>";

					// $debug[$key]["content"] = $res;

				} else {
					$debug[$key]["info"][] = "Connection Failed !!";
					$debug[$key]["info"][] = "Error Code: <b>" . curl_errno($ch) . "</b>";
					$debug[$key]["info"][] = "Error: <b>" . curl_error($ch) . "</b>";
					break;
				}
				curl_close($ch);
			}
		}
		foreach($debug as $k=>$v){
			echo "<ul>";
			foreach($v["info"] as $info){
				echo "<li>".$info."</li>";
			}
			echo "</ul>";

			echo "<hr/>";
		}
		die;
	}
}