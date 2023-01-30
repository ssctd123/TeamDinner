import { Injectable } from "@nestjs/common";
import { FirebaseRepository } from "./firebase.repository";
import { Firebase } from "../../../utils/firebase";
import { Team } from "../../entities/Team";
import { firestore } from "firebase-admin";
import { User } from "../../entities/User";
import DocumentReference = firestore.DocumentReference;
import DocumentData = firestore.DocumentData;

@Injectable()
export class TeamsRepository extends FirebaseRepository {
	constructor(firebase: Firebase) {
		super(firebase, "teams");
	}

	async getTeam(teamID: string): Promise<Team> {
		const data: DocumentData = await this.collection
			.doc(teamID)
			.get()
			.then((doc) => doc.data());
		return data as User;
	}

	async getTeams(): Promise<Team[]> {
		const snapshot: firestore.QuerySnapshot = await this.collection.get();
		return snapshot.docs.map((doc) => doc.data()) as Team[];
	}

	async createTeam(team: Team): Promise<Team> {
		const teamDoc: DocumentReference = await this.collection.doc(team.id);
		await teamDoc.set(team);
		return this.getTeam(team.id);
	}

	async checkOwner(id: string): Promise<boolean> {
		const snapshot: firestore.QuerySnapshot = await this.collection
			.where("owner", "==", id)
			.get();
		console.log(snapshot.docs.length);
		return snapshot.docs.length > 0;
	}

	async addMember(teamId: string, userId: string): Promise<Team> {
		const docRef: DocumentReference = await this.collection.doc(teamId);
		await docRef.update({
			members: firestore.FieldValue.arrayUnion(userId)
		});
		return await this.getTeam(teamId);
	}

	async removeMember(teamId: string, userId: string): Promise<Team> {
		const docRef: DocumentReference = await this.collection.doc(teamId);
		await docRef.update({
			members: firestore.FieldValue.arrayRemove(userId)
		});
		return await this.getTeam(teamId);
	}

	async userOnTeam(id: string): Promise<boolean> {
		const snapshot: firestore.QuerySnapshot = await this.collection
			.where("members", "array-contains", id)
			.get();
		return snapshot.docs.length > 0;
	}

	//
	// async deleteTeam(teamID: string): Promise<void> {
	//   await this.queryBuilder
	//     .where({
	//       id: teamID,
	//     })
	//     .del();
	// }
}
