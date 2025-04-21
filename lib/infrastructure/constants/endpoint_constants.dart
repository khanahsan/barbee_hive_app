class Endpoints{


  static const String baseUrl = 'https://api.shoplocalclubcard.com';

  ///User apis
  static const String login = '/api/v1/user/login';
  static const String checkEmail = '/api/v1/user/check_email';
  static const String emailVerifyResend='/api/v1/user/email_verify_resend';
  static const String register = '/api/v1/user/register';
  static const String emailVerify='/api/v1/user/email_verify';
  static const String passwordRestoreSend='/api/v1/user/password_restore_send/';
  static const String passwordRestoreReset='/api/v1/user/password_restore_reset';
  static const String userProfile='/api/v1/user/profile';
  static const String updateProfile = '/api/v1/user/profile_save';
  static const String searchUser = '/api/v1/user/search';
  static const String logout = '/api/v1/user/logout';
  static const String usersCheckInLocations = '/api/v1/user/check_in_locations';


  ///notification
  static const String getNotifications='/api/v1/notification/';
  static const String markNotificationSeen='/api/v1/notification/seen/';


  ///shops
  static const String shopList='/api/v1/shop/';

  ///stamp card apis end point:
  static const String userStampCards = '/api/v1/stampcard';
  static const String userStampCardsArchived = '/api/v1/stampcard/archive';
  static const String addStamp = '/api/v1/stampcard/stamp/';
  static const String removeStamp = '/api/v1/stampcard/destroy/stamp/';
  static const String claimStampCard = '/api/v1/stampcard/claim/';
  static const String payOffStampCard = '/api/v1/stampcard/pay_off/';
  static const String finishStampCard = '/api/v1/stampcard/finish/';//stampcardUserShop.id

  ///vouchers: logged in users vouchers
  static const String mineVouchers = '/api/v1/voucher/mine';
  static const String archivedVouchers = '/api/v1/voucher/mine/archive';



  ///categories: Base url is same as of $countriesEndPoints
  static const String categories = '/api/v1/ref/shop_categories';



  ///favourite
  static const String getFavourites = '/api/v1/favorite/';
  static const String likeAShop = '/api/v1/favorite/store/';
  static const String unlikeShop = '/api/v1/favorite/unlike/';



  ///member
  static const String qrCode = '/api/v1/member/qr_code';
  static const String memberUser = '/api/v1/member/user';
  static const String memberTransaction = '/api/v1/member/transactions/';

  ///location
  static const String checkIn = '/api/v1/location/check_in/';
  static const String checkOut = '/api/v1/location/check_out/';
  static const String nearByShops = '/api/v1/location/nearby';
  static const String getSpecificShop = '/api/v1/location/show/';
  static const String clientsCheckIn = '/api/v1/location/clients_check_ins/';


  ///operators
  static const String userOperatedShops = '/api/v1/operator';
  static const String operatorOperate = '/api/v1/operator/operate/';


  ///Store Sale
  static const String saleStore = '/api/v1/sale/store/';//Shop.id


// static const String baseUrl = '';
  // static const String baseUrl = '';
  // static const String baseUrl = '';



}
