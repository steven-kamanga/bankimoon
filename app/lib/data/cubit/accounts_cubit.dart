import 'package:bankimoon/data/repo.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final Repository repository;
  AccountsCubit({required this.repository}) : super(AccountsInitial());

//fetch user accounts
  void useraccounts() {
    emit(FetchingAccounts());
    repository.getAccounts().then((value) {
      emit(
        AccountsFetched(accounts: value),
      );
    }).catchError((err) {
      emit(AccountFetchError(message: 'Got error $err'));
    });
  }

  // Fetch favourited accounts from the stoe
  void favouritedAccounts() {
    emit(FetchingAccounts());
    repository.getFavourites().then((value) {
      emit(
        AccountsFetched(accounts: value),
      );
    }).catchError((err) {
      emit(AccountFetchError(message: 'Got error $err'));
    });
  }

  // add account
  void addAccount(institutionName, accountName, accountNumber) {
    emit(SubmittingAccount());
    repository
        .addAccount(institutionName, accountName, accountNumber)
        .then((value) {
      emit(
        AccountSubmitted(
          msg: value['msg'],
        ),
      );
    });
  }

  // Search account
  void searchAccount(String query) {
    repository.searchAccount(query).then((value) {
      emit(AccountSearchResults(accounts: value));
    }).catchError((err) {
      emit(AccountFetchError(message: 'Got error $err'));
    });
  }

  void searchFavouriteAccounts(String query) {
    repository.searchFavouriteAccounts(query).then((value) {
      emit(AccountSearchResults(accounts: value));
    }).catchError((err) {
      emit(AccountFetchError(message: 'Got error $err'));
    });
  }

  void markAsFavourite(int accountId) {
    repository.markAsFavourite(accountId);
    
    repository.getAccounts().then((value) {
      emit(AccountsFetched(accounts: value));
    });
  }

  // delete account
  void deleteAccount(int id) {
    repository.deleteAccount(id);

    repository.getAccounts().then((value) {
      emit(AccountsFetched(accounts: value));
    });
  }

  // nuke all accounts from db
  void nukeAccounts() {
    emit(DeletingAccounts());
    repository.deleteAccounts().then((value) => {
          emit(
            AccountsDeleted(
              msg: value['msg'],
            ),
          )
        });
  }
}
