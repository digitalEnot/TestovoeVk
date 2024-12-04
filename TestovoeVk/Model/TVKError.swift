//
//  TVKError.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 04.12.2024.
//

import Foundation


enum TVKError: String, Error {
    case problemsWithURL = "Проблема с url!"
    case problemsWithTheNetwork = "Произошла ошибка при загрузке медиаконтента. Проверь свое интернет соединение."
    case problemsWithDecodingData = "Проблемы с декодированиеим."
    
    case cantSaveToTheStorage = "Проблемы с сохранением контента в storage."
    case cantDeleteFromTheStorage = "Проблемы с удалением контента из storage."
}
