# Iris

Сервис по сбору информации о версиях `Ruby` и `Rails` по проектам enicad gitlab. Помимо этого сервис собирает информацию
о версиях `bundler`, `rake` и `capistrano` гемов. Если на проекте используется `capistrano`, тогда так же сравниваются версия
`Ruby` по проекту с версией `Ruby` внутри `config/deploy.rb`. Основываясь на `rails.gemspec`, `ruby` и `bundler` версии
анализируются на соответствие версии `Rails`, если таковая присутствует на проекте.

Помимо этого, версия каждого из вышеперечисленных гемов проверяется на соответствие минимально принятой версии из списка
минимально допустимых версий (`VersionsSettings`). Все проекты, на которых выявлены отставания по версиям, или нарушение зависимостей между версиями
подсвечиваются. Причины несоответствия можно прочесть в `tooltips` к каждой строке (к каждому проекту).

# Как это работает

Сервис представляет собой приложение, которое запущено постоянно. Раз в некоторый промежуток времени (предположительно один раз в день) по крону
стартует rake таска `lib/tasks/collect_projects_info.rake`. Эта таска бегает в наш gitlab, получает список проектов и для каждого проекта тянет несколько фалов,
например, `.ruby-version`, `Gemfile.lock` etc, которые парсятся, и таким образом строится актуальная информация по текущим версиям ruby и некоторых гемов на проекте.
Все данные складываются в БД.

Интерфейс пользователя представлен двумя страницами: основная - таблица с проектами и с информацией о версиях по каждому проекту,
вторая страница - форма для редактирования актуальных по проектам версий, то есть устанавливаются ограничения, что на каждом проекте,
например, ruby версия не ниже установленной и т.п.

Так же, на основной странице подсвечиваются проекты, на которых есть проблемы несоответствия версий.

Кнопка "Подтянуть версии из Internet", на странице редактирования, позволяет обновить список валидных версий, котоыре затем можно
выбирать в выпадающем меню.

# VersionsSettings и versions_checking.yml

При первом запуске выполните `seed` для генерации `VersionsSettings`. При этом из интернета будет подтянут список
допустимых версий для каждого гема и Ruby. Так же обновить список доступных версий можно будет через интерфейс по кнопке
со страницы `/requirements`. Так же в процессе выполнения `seed` будут проинициализированы значения минимально допустимых версий.

Файл `versions_checking.yml`:

`check_versions_for` - сущности, для которых проводятся проверки на проекте

`rails_dependency` - содержит в себе информацию о допустимых версиях `ruby` и `bundler` в соответствии с версией `Rails`.
Пожалуйста, соблюдайте правила, по которым отредактирован этот файл:
- между знаком условия и версией должен быть пробел
- если существует более одного условия для гема, перечисляйте их в одной строке через запятую
- версии определенные с использованием `~>` должны быть преобразованы в `>=` и `<`. Например, `~> 3.0` в `>= 3.0.0, < 3.1.0`

Зависимости взяты с `rails` репозитория. 

# Настройка конфигурации

**Скопируйте конфу по-умолчанию**

    cp config/database.yml.sample config/database.yml
    cp .env.sample .env

Обратите внимание, что `.env` содержит предварительные настройки для локального запуска. Вам также понадобится сгенерировать
`Personal Access Token` в своем gitlab профиле и проинициализировать им env-переменную `GITLAB_ACCESS_TOKEN`.
Как это сделать, можно прочесть [здесь](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html).

# Первый запуск проекта

**Без докера**

    bundle install
    bundle exec rake db:create
    bundle exec rake db:migrate
    bundle exec rake db:seed
    bundle exec rake collect_projects_info
    puma -C config/puma.rb

**C docker-compose**

    cp compose/docker-compose.development.yml docker-compose.yml 
    docker-compose run iris bundle exec rake db:create
    docker-compose run iris bundle exec rake db:migrate
    docker-compose run iris bundle exec rake db:seed
    docker-compose run iris bundle exec rake collect_projects_info
    docker-compose up

# Сбор информации по проектам

За сбор информации по проектам отвечает таска `collect_projects_info.rake`. 
Для запуска:

    bundle exec rake collect_projects_info

На проде эта таска запускается по расписанию. Список доступных для сбора информации проектов определяется разрешениями
для вашей gitlab учетной записи.
