require_relative '../models/item'

# Question.create(description: '¿?', detail: '')
# Option.create(description: '', isCorrect: false, question_id: 12)
# Option.create(description: '', isCorrect: true, question_id: 12)
# Option.create(description: '', isCorrect: false, question_id: 12)
# Option.create(description: '', isCorrect: false, question_id: 12)

Item.create(name: 'arceR', section: 'hoja', description: 'Arce Rojo', price: 15)
Item.create(name: 'canada', section: 'hoja', description: 'Canada Brown', price: 15)
Item.create(name: 'golden', section: 'hoja', description: 'Golden', price: 15)
Item.create(name: 'ocean', section: 'hoja', description: 'Ocean', price: 15)
Item.create(name: 'sunset', section: 'hoja', description: 'Sunset', price: 15)
Item.create(name: 'roble', section: 'hoja', description: 'Roble', price: 15)
Item.create(name: 'forest', section: 'fondo', description: 'Forest', price: 15)
Item.create(name: 'paradise', section: 'fondo', description: 'Paradise', price: 15)
Item.create(name: 'sabana', section: 'fondo', description: 'Sabanna', price: 15)
Item.create(name: 'jungle', section: 'fondo', description: 'Jungle', price: 15)
