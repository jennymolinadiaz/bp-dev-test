@MarvelTodos
Feature: Obtener personajes de Marvel

    Background:
        * def base_url = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
        * header content-type = 'application/json'

    Scenario: Consultar lista de personajes
        Given url base_url
        When method GET
        Then status 200
        And print response.data.results

    @ConsultarMarvelID
    Scenario: Obtener personaje de Marvel por ID
        * def character_id = '28'
        Given url base_url + '/' + character_id
        When method GET
        Then status 200
        And print response.data.results

    @ConsultarMarvelIDNoExiste
    Scenario: Obtener personaje de Marvel por ID que no existe
        * def character_id = '9999'
        Given url base_url + '/' + character_id
        When method GET
        Then status 404
        And match response == { error: '#notnull' }

    @CrearPersonaje
    Scenario: Crear personaje Marvel
        Given url base_url
        And request { name: 'Superheroe', description: 'Defensor del pueblo',alterego:'Superheroe',powers:['sanar con risa','volar'] }
        When method POST
        Then status 201
        And match response == { id: '#notnull', name: 'Superheroe', description: 'Defensor del pueblo',alterego:'Superheroe',powers:['sanar con risa','volar']}

    @CrearPersonajeDuplicado
    Scenario: Crear personaje que ya se encuentra en la lista de Marvel
        Given url base_url
        And request { name: 'Super Madre', description: 'Puede hacer varias cosas',alterego:'Luz Toaquiza', powers: ['Amor','Comprensión'] }
        When method POST
        Then status 409
        And match response == { error: '#notnull' }

    @CrearPersonajeCampos
    Scenario: Crear personaje que falta campos requeridos como nombre, descripcion, poderes
        Given url base_url
        And request { }
        When method POST
        Then status 400
        And match response == { error: '#notnull' }

    @ActualizarPersonajeExitoso
    Scenario: Actualizar los campos del personaje que si existe en la lista de Marvel
        * def character_id = '28'
        Given url base_url + '/' + character_id
        And request { name: 'Superheroe7', description: 'Se convierte en super villano' }
        When method PUT
        Then status 200
        And match response == { id: '28', name: 'Superheroe7', description: 'Se convierte en super villano' }

    @ActualizarPersonajeError
    Scenario: Actualizar los campos del personaje que no existe en la lista de Marvel
        * def character_id = '9999'
        Given url base_url + '/' + character_id
        And request { name: 'SuperheroeX', description: 'Personaje inexistente' }
        When method PUT
        Then status 404
        And match response == { error: '#notnull' }

    @EliminarPersonajeOk
    Scenario: Eliminar exitosamente un personaje de la lista de Marvel
        * def character_id = '28'
        Given url base_url + '/' + character_id
        When method DELETE
        Then status 200
        And match response == { message: 'Personaje eliminado exitosamente' }

    @EliminarPersonajeErr
    Scenario: Eliminar un personaje de la lista de Marvel que no existe
        * def character_id = '9999'
        Given url base_url + '/' + character_id
        When method DELETE
        Then status 404
        And match response == { error: '#notnull' }