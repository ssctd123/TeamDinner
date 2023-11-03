import { Injectable } from "@nestjs/common";
import { FirebaseRepository } from "./firebase.repository";
import { Firebase } from "../../../utils/firebase";
import { Message } from "../../entities/Message";
import { firestore } from "firebase-admin";

@Injectable()
export class MessagesRepository extends FirebaseRepository {
constructor(firebase: Firebase) {
		super(firebase, "messages");
	}

	async createMessage(message: Message): Promise<Message> {
		const doc = await this.collection.doc(message.id);
		await doc.set(message);
		return await this.get(doc.id);
	}

    async get(id: string): Promise<Message> {
		const data = await this.collection
			.doc(id)
			.get()
			.then((doc) => doc.data());
		return data as Message;
	}
}