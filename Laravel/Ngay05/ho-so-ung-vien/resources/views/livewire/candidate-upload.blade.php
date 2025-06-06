<div>
    <label for="avatar">Ảnh đại diện</label>
    <input type="file" id="avatar" wire:model="avatar" class="form-control">

    @error('avatar') <span class="text-danger">{{ $message }}</span> @enderror

    @if ($avatar)
        <div class="mt-3">
            <p class="fw-bold">Xem trước:</p>
            <img src="{{ $avatar->temporaryUrl() }}" class="img-thumbnail" style="max-height: 200px;">
        </div>
    @endif
</div>
