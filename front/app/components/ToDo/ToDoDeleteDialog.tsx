import React, {ReactElement, useState} from "react";
import {Button, DeleteSVGIcon, Dialog, DialogContent, DialogFooter, Text} from "react-md";

interface ToDoDeleteDialogProps {
    toDoId: string
    destroyToDos: (toDoId: string) => void
}

export default function ToDosDeleteDialog({toDoId, destroyToDos}: ToDoDeleteDialogProps): ReactElement {
    const [state, setState] = useState({visible: false, modal: false});
    const hide = (): void => {
        setState((prevState) => ({...prevState, visible: false}));
    };
    const show = (event: React.MouseEvent<HTMLButtonElement>): void => {
        setState({
            visible: true,
            modal: event.currentTarget.id === "dialog-button",
        });
    };
    const {visible, modal} = state;

    function deleteToDo() {
        hide()
        destroyToDos(toDoId)
    }

    return (
        <>
            <Button
                id="dialog-button"
                onClick={show}>
                <DeleteSVGIcon/>
            </Button>
            <Dialog
                id="todo-delete-dialog"
                modal={modal}
                visible={visible}
                onRequestClose={hide}
                aria-labelledby="delete-dialog">
                <DialogContent>
                    <Text>目標を削除します。</Text>
                </DialogContent>
                <DialogFooter>
                    <Button id="dialog-cancel" onClick={hide}>
                        Cancel
                    </Button>
                    <Button id="dialog-add" onClick={() => {
                        deleteToDo()
                    }}>
                        Delete
                    </Button>
                </DialogFooter>
            </Dialog>
        </>
    )
}
