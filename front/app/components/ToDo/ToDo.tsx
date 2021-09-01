import React, {ReactElement, useEffect, useState} from "react";
import {TextField} from "@react-md/form"
import {Text} from "react-md"
import styles from "./ToDo.module.scss"

interface ToDo {
    id: string
    title: string
}

interface ToDoProps {
    toDo: ToDo
    updateToDo: (toDo: ToDo) => Promise<ToDo>
}

export default function ToDo({toDo, updateToDo}: ToDoProps): ReactElement {
    const [selectedToDo, setSelectedToDo] = useState<ToDo>({id: '', title: ''})

    useEffect(() => {
        setSelectedToDo(toDo)
    }, [toDo])

    function editToDo(editToDo: ToDo) {
        updateToDo(editToDo).then(() => {})
    }

    function changeToDo(editToDo: ToDo) {
        const newToDo = {id: editToDo.id, title: editToDo.title}
        setSelectedToDo(newToDo)
    }

    return (
        <div className={styles.div}>
            <Text type="headline-5">ToDo Title</Text>
            <TextField id="textField"
                       value={selectedToDo.title}
                       theme={"underline"}
                       type={"text"}
                       onChange={(event) => {
                           selectedToDo.title = event.target.value
                           changeToDo(selectedToDo)
                       }}
                       onBlur={() => {
                           editToDo(selectedToDo)
                       }}
                       placeholder="TODO"/>
        </div>
    )
}
