import { Injectable } from "@nestjs/common";
import { FirebaseRepository } from "./firebase.repository";
import { Firebase } from "../../../utils/firebase";
import { Location } from "../../entities/Location";
import { firestore } from "firebase-admin";

@Injectable()
export class LocationsRepository extends FirebaseRepository {
    constructor(firebase: Firebase) {
		super(firebase, "locations");
	}

	async createLocation(location: Location): Promise<Location> {
		const doc = await this.collection.doc(location.id);
		await doc.set(location);
		return await this.get(doc.id);
	}

    async get(id: string): Promise<Location> {
		const data = await this.collection
			.doc(id)
			.get()
			.then((doc) => doc.data());
		return data as Location;
	}
}