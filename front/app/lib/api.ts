import axios from "axios";
// const baseUrl = 'http://localhost:3000'
const baseUrl = process.env.NEXT_PUBLIC_BASE_URL

interface RequestToDo {
    id: string
    title: string
}

interface RequestToDoList {
    id: string
    todo_id: string
    content: string
    complete: boolean
}

export const getTodos = async () => {
    return axios.get(encodeURI(`${baseUrl}/api/todos`))
}

export const getTodo = async (id: string) => {
    return axios.get(encodeURI(`${baseUrl}/api/todos/${id}`))
}

export const addToDo = async (postData: RequestToDo) => {
    return axios.post(encodeURI(`${baseUrl}/api/todos`), postData)
}

export const editToDo = async (putData: RequestToDo) => {
    return axios.put(encodeURI(`${baseUrl}/api/todos/${putData.id}`), putData)
}

export const deleteTodo = async (id: string) => {
    return axios.delete(encodeURI(`${baseUrl}/api/todos/${id}`))
}

export const getToDoLists = async (todoId: string) => {
    return axios.get(encodeURI(`${baseUrl}/api/todos/${todoId}/todo_lists`))
}

export const addToDoList = async (todoId: string, postData: RequestToDoList) => {
    return axios.post(encodeURI(`${baseUrl}/api/todos/${todoId}/todo_lists`), postData)
}

export const editToDoList = async (todoId: string, putData: RequestToDoList) => {
    return axios.put(encodeURI(`${baseUrl}/api/todos/${todoId}/todo_lists/${putData.id}`), putData)
}

export const deleteToDoList = async (todoId: string, id: string) => {
    return axios.delete(encodeURI(`${baseUrl}/api/todos/${todoId}/todo_lists/${id}`))
}
