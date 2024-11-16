# Практика 11 Столяров ЭФБО-01-22 22T0318

## Задание.
Следуя руководству из видеоролика, создать форму регистрации и авторизации, используя supabase.

## Ход выполнения
### Шаг 1. Настройка аутентификации в supabase

![alt text](screenshot/image.png)

### Шаг 2. Установка клиента supabase

<pre>flutter pub add supabase_flutter</pre>

### Шаг 3. Создание страниц логина и регистрации

![alt text](/screenshot/image2.png)

![alt text](/screenshot/image3.png)

### Шаг 4. Тестируем регистрацию, вход и выход
Примечание. С недавних пор supabase требует SMTP сервер для отправки email-подтверждений (без них возникает исключение при регистрации). Поэтому регистрация работает только для моего собственного email адреса.
https://stackoverflow.com/questions/79047884/supabase-error-email-address-cannot-be-used-as-it-is-not-authorized


![alt text](screenshot/image4.png)


![alt text](screenshot/image5.png)

Подтверждаем почту по ссылке из сообщения
![alt text](screenshot/image6.png)


Теперь в supabase появился наш пользователь
![alt text](screenshot/image7.png)

Можно войти и посмотреть на свои данные
![alt text](screenshot/image8.png)

(Телефон всё еще остаётся заглушкой)
![alt text](screenshot/image9.png)

По нажатию на Выйти, происходит Logout() и возвращается экран со входом.