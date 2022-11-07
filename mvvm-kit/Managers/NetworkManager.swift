//
//  NetworkManager.swift
//  TestTask
//
//  Created by Владислав Пермяков on 29.10.2022.
//

import Foundation
import Alamofire



///список ошибок
enum APIError: Error{
    ///стандартная ошибка с кодом статуса
    case network(Int)
    case parseError
    
}

extension APIError{
    func humanRepresentation() -> String{
        switch self {
        case .network(_):
            return "Server error, please check your connection or contact the support"
        case .parseError:
            return "Internal error, please contact the suppor and report the error"
        }
    }
}


///Класс отвечающий за работу с запросами
public class NetworkManager{
    private init(){}
    public static let shared = NetworkManager()
    
    func httpFailCheck<T>(response: DataResponse<T, AFError> ) throws{
        
        guard (200...299).contains(response.response?.statusCode ?? 0) else {
            print(response.response?.url as Any)
            print(response.response?.statusCode as Any)
            //здесь далее можно спокойно обработать определенные статусы, например 401 или 500
            throw APIError.network(response.response?.statusCode ?? 0)
        }
    }
    
    ///создание запроса принимающее url, тип метода, параметры и энкодер
    private func request<T: Codable>(url: String, method: HTTPMethod, params: Parameters?, encoder: ParameterEncoding = URLEncoding.default) async throws -> T{
        //cобираем запрос и делаем его
        let request = AF.request(url, method: method, parameters: params, encoding: encoder, headers: nil).serializingDecodable(T.self)
        let response = await request.response
        //проверяем запрос на ошибку
        try httpFailCheck(response: response)
        //исключение на удаление, когда data не возвращается
        if response.response?.statusCode == 204 {
            //если нет контента, но удачный статус удаления
            if Bool.self is T, let answer = true as? T{
                //Дженерик bool, значит при удачном запросе можем возвращать true
                return answer
            }else{
                //вызывающая функция просит не Bool, однако в случае бекенда нашей команды при удалении должно приходить No Data и вызывающая функция для подтверждения должна просить Bool
                throw APIError.parseError
            }
        }else{
            //пытаемся получить данные из запроса
            guard let value = response.value else {
                //не удалось спарсить, проверяем есть ли данные вообще
                if let data = response.data{
                    print(String(data: data, encoding: .utf8) as Any)
                    do{
                        let _ = try JSONDecoder().decode(T.self, from: data)
                    }catch{
                        print(error)
                    }
                }
                
                print(url)
                print("got data success but couldn't parse it to Model")
                throw APIError.parseError
            }
            //возвращаем полученые данные
            return value
        }
    }
    
    func getHotelsList() async throws -> [Hotel]{
        let url = "https://raw.githubusercontent.com/iMofas/ios-android-test/master/0777.json"
        let data = try await NetworkManager().request(url: url, method: .get, params: nil) as [Hotel]
        return data
    }
    
    func getHotelDetails(_ id: Int) async throws -> Hotel{
        let url = "https://raw.githubusercontent.com/iMofas/ios-android-test/master/\(id).json"
        let data = try await NetworkManager().request(url: url, method: .get, params: nil) as Hotel
        return data
    }
    func getHotelImage(_ id: String) async throws -> UIImage?{
        let url = "https://github.com/iMofas/ios-android-test/raw/master/\(id)"
        let request = AF.request(url, method: .get)
        let data = try await request.serializingData().value
        let image = UIImage(data: data)
        return image
        
    }
}
