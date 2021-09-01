import React, {ReactElement, useEffect, useState} from "react";
import ToDoComponent from "../../components/ToDo/ToDo";
import ToDoListComponent from "../../components/ToDoList/ToDoList"
import { useRouter } from 'next/router';
import {addToDoList, deleteToDoList, editToDo, editToDoList, getTodo, getToDoLists} from "../../lib/api";

interface ToDo {
    id: string
    title: string
}

interface ToDoList {
    id: string
    content: string
    complete: boolean
}

export default function ToDo(): ReactElement {
    const router = useRouter();
    const [toDoId] = useState<string>(() => {
        return (typeof router.query.id === "string") ? router.query.id : "";
    })
    const [toDo, setToDo] = useState<ToDo>({id: '', title: ''})
    const [toDoList, setToDoList] = useState<ToDoList[]>([])

    useEffect(() => {
        getTodo(toDoId).then((response) => {
            setToDo(response.data)
        })
        getToDoLists(toDoId).then((response) => {
            setToDoList(response.data)
        })
    }, [toDoId])

    async function createToDoList(createToDoList: ToDoList) {
        const requestToDoList = {id: '', todo_id: toDoId, content: createToDoList.content, complete: createToDoList.complete}
        const response = await addToDoList(toDoId, requestToDoList)
        const resToDoList: ToDoList = {id: response.data.id, content: response.data.content, complete: response.data.complete}
        toDoList.push(resToDoList)
        const newToDoList = toDoList.slice()
        setToDoList(newToDoList)
        return resToDoList
    }

    async function updateToDoList(updateTotoDoList: ToDoList) {
        const requestToDoList = {id: updateTotoDoList.id, todo_id: toDoId, content: updateTotoDoList.content, complete: updateTotoDoList.complete}
        const response = await editToDoList(toDoId, requestToDoList)
        const resToDoList: ToDoList = {id: response.data.id, content: response.data.content, complete: response.data.complete}
        const index = getIndex(resToDoList.id)
        toDoList.splice(index, 1, resToDoList)
        const newToDoList = toDoList.slice()
        setToDoList(newToDoList)
        return resToDoList
    }

    async function destroyToDoList(toDoListId: string) {
        await deleteToDoList(toDoId, toDoListId)
        const index = getIndex(toDoListId)
        toDoList.splice(index, 1)
        const newToDoList = toDoList.slice()
        setToDoList(newToDoList)
        return true
    }

    async function updateToDo(updateToDo: ToDo) {
        const response = await editToDo(updateToDo)
        const resToDo: ToDo = {id: response.data.id, title: response.data.title}
        setToDo(resToDo)
        return resToDo
    }

    function getIndex(id: string): number {
        return toDoList.findIndex(toDoList => toDoList.id === id)
    }

    return (
        <>
            <ToDoComponent toDo={toDo} updateToDo={updateToDo}/>
            <ToDoListComponent
                toDoList={toDoList}
                createToDoList={createToDoList}
                updateToDoList={updateToDoList}
                destroyToDoList={destroyToDoList}/>
        </>
    )
}
