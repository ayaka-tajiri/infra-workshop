import React, {ReactElement, useEffect, useState} from "react";
import ToDosComponent from "../../components/ToDos/ToDos"
import {addToDo, deleteTodo, getTodos} from "../../lib/api";

interface ToDo {
    id: string
    title: string
}

export default function ToDos(): ReactElement {
    const [toDos, setToDos] = useState<ToDo[]>([])

    useEffect(() => {
        getTodos().then((response) => {
            setToDos(response.data)
        })
    }, [])

    function createToDo(createToDo: ToDo) {
        addToDo(createToDo).then((response) => {
            toDos.push(response.data)
            const newToDos = toDos.slice()
            setToDos(newToDos)
        })
    }

    function deleteToDo(toDoId: string) {
        deleteTodo(toDoId).then(() => {
            const index = getIndex(toDoId)
            toDos.splice(index, 1)
            const newToDos = toDos.slice()
            setToDos(newToDos)
        })
    }

    function getIndex(id: string): number {
        return toDos.findIndex(toDo => toDo.id === id)
    }

    return (
        <ToDosComponent toDos={toDos} addToDo={createToDo} deleteToDo={deleteToDo}/>
    )
}
