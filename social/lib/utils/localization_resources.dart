import 'package:social/utils/disk_resources.dart';

class LocalizationResources {
  static void updateResources() {
    var currentLanguage = DiskResources.getString('language');
    if ((currentLanguage?.isEmpty ?? true) || currentLanguage == 'Türkçe') {
      somethingWentWrongError = 'Beklenemeyen bir hata oldu!';
      areYouSureToExit = 'Çıkmak istediğine emin misin?';
      profileUpdatedSuccessfully = 'Profil güncellendi!';
      wrongCredentials = 'Bilgiler hatalı!';
      deosntHaveAnAccount = 'Hesabın yok mu?';
      sendEmailForPassword = 'Şifre için mail gönder';
      pickACategory = 'Bir kategori seç!';
      youJoinedActivitySuccessfully = 'Aktiviteye başarıyla katıldın!';
      goToChatRoom = 'Mesaj odasına git';
      noSpaceForTheActivity = 'Aktivite kapasitesi dolu!';
      activityShouldBeCreated48HoursBeforeIt = 'Aktivite 48 saat öncesinden oluşturulmalı!';
      pleaseEnterATitle = 'Bir başlık giriniz!';
      pleaseEnterDetails = 'Detayları giriniz!';
      pleaseEnterALocation = 'Bir konum giriniz!';
      pleaseEnterAValidPhoneNumber = 'Lütfen geçerli bir telefon numarası giriniz!';
      pleasePickACategory = 'Lütfen bir kategori seçiniz!';
      userNameLengthShouldBe5OrGreater = 'Kullanıcı adı uzunluğu 5 ve ya daha fazla olmalıdır!';
      passwordLengthShouldBe5OrGreater = 'Şifre adının uzunluğu 5 ve ya daha fazla olmalıdır!';
      fromDateShouldBeBeforeOrEqualToToDate = 'Bitiş tarihi başlangıç tarihinden önce olamaz!';
      haveAnAccount = 'Hesabın var mı?';
      noActivities = 'Aktivite bulunamadı';
      youHaveCreatedActivitySuccessfully = 'Aktivite başarılı bir şekilde oluşturuldu';
      youHaveCreatedAccountSuccessfully = 'Hesap başarılı bir şekilde oluşturuldu';

      settings = 'Ayarlar';
      info = 'Bilgilendirme';
      fail = 'Hata';
      success = 'Başarılı';
      yes = 'Evet';
      no = 'Hayır';
      ok = 'Tamam';
      language = 'Dil';
      signIn = 'Kayıt ol';
      login = 'Giriş yap';
      userName = 'Kullanıcı adı';
      password = 'Şifre';
      profile = 'Profil';
      joinedOnes = 'Katıldıkların';
      createdOnes = 'Oluşturdukların';
      nameAndSurname = 'Ad & Soyad';
      about = 'Hakkında';
      save = 'Kaydet';
      forgotPassword = 'Şifremi unuttum';
      email = 'Mail';
      other = 'Diğerleri';
      from = 'Başlangıç';
      to = 'Bitiş';
      capacity = 'Kapasite'; 
      reset = 'Sıfırla'; 
      search = 'Ara'; 
      goToProfile = 'Profile git'; 
      category = 'Kategori';
      date = 'Tarih';
      time = 'Saat';
      location = 'Konum';
      phoneNumber = 'Tel No';
      joiners = 'KATILIMCILAR';
      join = 'Katıl';
      title = 'Başlık';
      detail = 'Detay';

      activities = 'Aktiviteler';
      createdActivites = 'Oluşturulan Aktiviteler';
      joinedActivites = 'Katınılan Aktiviteler';
      activityBuilder = 'Aktivite Oluşturma'; 

      picnic = 'Piknik';
      cinema = 'Sinema';
      sport = 'Spor';
      
    } else {
      somethingWentWrongError = 'Something went wrong';
      areYouSureToExit = 'Are you sure to exit?';
      profileUpdatedSuccessfully = 'Profile updated successfully';
      wrongCredentials = 'Wrong credentials';
      deosntHaveAnAccount = 'Don\'t you have an account?';
      sendEmailForPassword = 'Send email for password';
      pickACategory = 'Pick a category';
      youJoinedActivitySuccessfully = 'You joined activity succesfully!';
      goToChatRoom = 'Go to chat room';
      noSpaceForTheActivity = 'No space for the activity';
      activityShouldBeCreated48HoursBeforeIt = 'Activity should be created 48 hours before it';
      pleaseEnterATitle = 'Please enter a title';
      pleaseEnterDetails = 'Please enter details';
      pleaseEnterALocation = 'Please enter a location';
      pleaseEnterAValidPhoneNumber = 'Please enter a valid phone number';
      pleasePickACategory = 'Please pick a category';
      userNameLengthShouldBe5OrGreater = 'Username\'s length should be 5 or greater';
      passwordLengthShouldBe5OrGreater = 'Password\'s length should be 5 or greater';
      fromDateShouldBeBeforeOrEqualToToDate = 'Before date should be before or equal to to date';
      haveAnAccount = 'Have an account?';
      noActivities = 'No activities!';
      youHaveCreatedActivitySuccessfully = 'You have created activity succesfully!';
      youHaveCreatedAccountSuccessfully = 'You have created account succesfully!';

      settings = 'Settings';
      info = 'Info';
      fail = 'Fail';
      success = 'Success';
      yes = 'Yes';
      no = 'No';
      ok = 'Ok';
      language = 'Language';
      signIn = 'Sign In';
      login = 'Login';
      userName = 'Username';
      password = 'Password';
      profile = 'Profile';
      joinedOnes = 'Joined Ones';
      createdOnes = 'Created Ones';
      nameAndSurname = 'Name & Surname';
      about = 'About';
      save = 'Save';
      forgotPassword = 'Forgot Password';
      email = 'Email';
      from = 'From';
      to = 'To';
      capacity = 'Capacity'; 
      reset = 'Reset'; 
      search = 'Search'; 
      goToProfile = 'Go to profile'; 
      category = 'Category';
      date = 'Date';
      time = 'Time';
      location = 'Location';
      phoneNumber = 'Phone Number';
      joiners = 'JOINERS';
      join = 'Join';
      title = 'Title';
      detail = 'Detail';

      activities = 'Activities';
      createdActivites = 'Created Activities';
      joinedActivites = 'Joined Activities';
      activityBuilder = 'Activity Builder'; 

      picnic = 'Picnic';
      cinema = 'Cinema';
      sport = 'Sport';
      other = 'Other';
    }
  }

  static String somethingWentWrongError = 'Beklenemeyen bir hata oldu!';
  static String areYouSureToExit = 'Çıkmak istediğine emin misin?';
  static String profileUpdatedSuccessfully = 'Profil güncellendi!';
  static String wrongCredentials = 'Bilgiler hatalı!';
  static String deosntHaveAnAccount = 'Hesabın yok mu?';
  static String haveAnAccount = 'Hesabın var mı?';
  static String sendEmailForPassword = 'Şifre için mail gönder!';
  static String pickACategory = 'Bir kategori seç!';
  static String youJoinedActivitySuccessfully = 'Aktiviteye başarıyla katıldın!';
  static String goToChatRoom = 'Mesaj odasına git';
  static String noSpaceForTheActivity = 'Aktivite kapasitesi dolu!';
  static String activityShouldBeCreated48HoursBeforeIt = 'Aktivite 48 saat öncesinden oluşturulmalı!';
  static String pleaseEnterATitle = 'Bir başlık giriniz!';
  static String pleaseEnterDetails = 'Detayları giriniz!';
  static String pleaseEnterALocation = 'Bir konum giriniz!';
  static String pleaseEnterAValidPhoneNumber = 'Lütfen geçerli bir telefon numarası giriniz!';
  static String pleasePickACategory = 'Lütfen bir kategori seçiniz!';
  static String userNameLengthShouldBe5OrGreater = 'Kullanıcı adı uzunluğu 5 ve ya daha fazla olmalıdır!';
  static String passwordLengthShouldBe5OrGreater = 'Şifre adının uzunluğu 5 ve ya daha fazla olmalıdır!';
  static String fromDateShouldBeBeforeOrEqualToToDate = 'Bitiş tarihi başlangıç tarihinden önce olamaz!';
  static String noActivities = 'No activities!';
  static String youHaveCreatedActivitySuccessfully = 'You have created activity succesfully!';
  static String youHaveCreatedAccountSuccessfully = 'You have created account succesfully!';

  static String settings = 'Ayarlar';
  static String info = 'Bilgilendirme';
  static String fail = 'Hata';
  static String success = 'Başarılı';
  static String yes = 'Evet';
  static String no = 'Hayır';
  static String ok = 'Tamam';
  static String language = 'Dil';
  static String signIn = 'Kayıt ol';
  static String login = 'Giriş yap';
  static String userName = 'Kullanıcı adı';
  static String password = 'Şifre';
  static String profile = 'Profil';
  static String joinedOnes = 'Katıldıkların';
  static String createdOnes = 'Oluşturdukların';
  static String nameAndSurname = 'Ad & Soyad';
  static String about = 'Hakkında';
  static String save = 'Kaydet';
  static String forgotPassword = 'Şifremi unuttum';
  static String email = 'Mail';
  static String from = 'Başlangıç';
  static String to = 'Bitiş';
  static String capacity = 'Kapasite'; 
  static String reset = 'Sıfırla'; 
  static String search = 'Ara'; 
  static String goToProfile = 'Profile git'; 
  static String category = 'Kategori';
  static String date = 'Tarih';
  static String time = 'Saat';
  static String location = 'Konum';
  static String phoneNumber = 'Tel No';
  static String joiners = 'KATILIMCILAR';
  static String join = 'Katıl';
  static String title = 'Başlık';
  static String detail = 'Detay';

  static String activities = 'Aktiviteler';
  static String createdActivites = 'Oluşturulan Aktiviteler';
  static String joinedActivites = 'Katınılan Aktiviteler'; 
  static String activityBuilder = 'Activity Builder'; 

  
  static String picnic = 'Piknik';
  static String cinema = 'Sinema';
  static String sport = 'Spor';
  static String other = 'Diğerleri';

  //will be updated later to get by reflection
  static String getCategory(String category){
    if(DiskResources.getString('language') == 'English'){
      return category;
    }
    if(category == 'picnic'){
      return 'Piknik';
    }
    if(category == 'cinema'){
      return 'Sinema';
    }
    if(category == 'sport'){
      return 'Spor';
    }
    if(category == 'other'){
      return 'Diğerleri';
    }
    return category;
  }
}
